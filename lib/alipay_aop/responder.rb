

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

      if responders.empty?
        fallbacks = self.responders(:fallback)
        return fallbacks.first unless fallbacks.empty?
      else
        responder_class = responders.detect {|x| x[:with].nil? }
        return responder_class.first unless responder_class.empty?
      end

      raise 'no responder matched for the request'
    end

    def self.handle_verifygw_event
      on :event, :with => :verifygw do
        @biz_content = api.public_key
        @signature = sign(@biz_content)
        render :verifygw
      end
    end



    def invoke_responder(responder)
      if responder[:respond].present?
        AlipayAOP.api.send_message(responder[:respond])
      elsif responder[:proc].present?
        responder[:proc].call(@request)
      else
        # just do nothing if no proc or respond specified
        nil
      end
    end

    def acknowledge_request
      @signature = api.sign(@request.biz_content_raw)
      render :acknowledge
    end


    # received a post request
    def create
      @request = Request.new(params)

      begin
        responder = self.class.responder_for(@request)
        invoke_responder(responder)
      rescue => e
        # exception has to be muted to reply the server,
        # better to log the error messages
      end

      acknowledge_request
    end


    def api
      AlipayAOP.api
    end
  end
end



if defined? ActionController::Base
  class ActionController::Base
    def self.alipay_aop_responder
      send :include, AlipayAOP::Responder
    end
  end
end
