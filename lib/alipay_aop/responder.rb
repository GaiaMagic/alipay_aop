

module AlipayAOP
  class Responder
    def self.on(type, with: nil, respond: nil, &block)
      raise 'Unknown message type' unless type.in? %i[text image voice video
                                                      location link event
                                                      fallback]
      config = respond.nil ? {} : {:respond => respond}
      config.merge!(:proc => block) if block_given?
      config.merge!(:with => with) if with.present?

      responders(type) << config

      return config
    end

    def self.responders type
      @responders ||= Hash.new
      @responders[type] ||= Array.new
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
