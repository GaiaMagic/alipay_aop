require '../../lib/alipay_aop'

module AlipayAOP
  class Controller < ApplicationController
    before_action :verify_signature, :only => :message_received
    before_action :set_up_request, :only => :message_received
    before_action :acknowledge_request, :only => :message_received


    def message_received
      type = request.msg_type
      handler = "#{type}_handler".intern

      unless respond_to? handler
        raise AlipayAOP::Error,
              "undefined handler for message type: #{type}"
      end

      send(handler)
    end

    def verifygw_handler
      if request.app_id == client.app_id

      else
        # not verified
      end
    end

    def event_handler

    end

    def text_handler

    end

    def image_handler

    end

    attr_accessor :client

    def client
      @client ||= AlipayAOP.client
    end

    private

    def acknowledge_request
      client.acknowledge_request(request)
    end

    def verify_signature
      client.server_key.verify(params['biz_content'],
                               params['signature'])
    end

    def set_up_request
      @request = Request.from_biz_content(params['biz_content'])
    end

    def request
      @request
    end

  end
end
