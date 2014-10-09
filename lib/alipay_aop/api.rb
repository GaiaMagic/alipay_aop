require 'ostruct'

require 'alipay_aop/client'

module AlipayAOP
  class Api
    attr_reader :private_key,
                :server_key,
                :client,
                :app_id

    API_GATEWAY = 'https://openapi.alipay.com/gateway.do'


    def initialize(app_id, private_key_file, alipay_public_key_file)
      @client = AlipayAOP::Client.new(app_id,
                                      API_GATEWAY,
                                      private_key_file,
                                      alipay_public_key_file)
    end

    def menu_create(menu)
      query('alipay.mobile.public.menu.add', JSON.generate(menu))
    end

    def menu_update(menu)
      query('alipay.mobile.public.menu.add', JSON.generate(menu))
    end

    def menu
      resp = query('alipay.mobile.public.menu.get', '{}')
      resp.menu_content = JSON.parse(resp.menu_content) if resp.code == 200
      resp
    end

    def custom_message(message)
      query('alipay.mobile.public.message.custom.send', message.to_json)
    end

    def broadcast(message)
      query('alipay.mobile.public.message.total.send', message.to_json)
    end

    def followers
      # paging for >10,000 followers is not handled yet
      resp = query('alipay.mobile.public.follow.list')
      return resp unless resp.code == 200
      resp.data['user_id_list']['string'].map {|x| User.from_id(x) }
    end

    def user_location(user)
      resp = query('alipay.mobile.public.gis.get',
                   JSON.generate({ :userId => user.id }))
      OpenStruct.new(resp)
    end


    private

    def query(service, content)
      client.request(service, content)
    end
  end
end
