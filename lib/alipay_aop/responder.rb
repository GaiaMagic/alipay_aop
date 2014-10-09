

module AlipayAOP
  class Responder
    def self.on(type, options = {}, &block)
      raise 'Unknown message type' unless type.in? %i[text image voice video
                                                      location link event
                                                      fallback]

      config = {}
      config.merge!(:respond => respond) if params[:respond]
      config.merge!(:proc => block) if block_given?
      config.merge!(:with => with) if with.present?

      responders(type) << config

      return config
    end

    def self.responders(type)
      @responders ||= Hash.new
      @responders[type] ||= Array.new
    end

    def self.responder_for(request)
      message_type = request.msg_type
      responders = responders(message)

      responder = case request.msg_type
                  when :event
                    match_responders(responders, request.event_type)
                  when :text
                    match_responders(responders, request.text)
                  when :image
                    match_responders(responders)
                  end

      responder
    end

    def self.match_responders(responders, value = nil)
      matched = responders.detect do |responder|
        responder[:with] and responder[:with] === value
      end

      return matched if matched
      return responders.first unless responders.empty?

      fallbacks = self.responders(:fallback)
      return fallbacks.first unless fallbacks.empty?

      raise 'no responder matched for the request'
    end

    def self.invoke_responder(responder, request)
      if responder[:respond].present?
        return AlipayAOP.api.send_message(responder[:respond])
      end

      return responder[:proc].call(request) if responder[:proc].present?

      # just do nothing if no proc or respond specified
      nil
    end


    # received a post request
    def create
      @request = Request.new(params)

      begin
        responder = self.class.responder_for(@request)
        self.invoke_responder(responder, @request)
      rescue => e
        # exception has to be muted to reply the server,
        # better to log the error messages
      end

      # TODO: acknowledge the server that the message has been received
    end

  end
end



if defined? ActionController::Base
  class ActionController::Base
    def self.wechat_responder
      send :include, AlipayAOP::Responder
    end
  end
end
