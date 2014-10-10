require 'alipay_aop/api'

module AlipayAOP
  class Reply
    attr_accessor :request

    def initialize(request)
      @request = request
    end

    def text(content)
      api.send_message(Message.new_text(content, request.from_user))
    end

    def image_text(attrs)
      api.send_message(Message.new_image_text(attrs,
                                              request.from_user))
    end

    def multiple_image_text(multi_attrs)
      api.send_message(Message.new_multiple_image_text(multi_attrs,
                                                       request.from_user))
    end


    def api
      AlipayAOP.api
    end
  end
end
