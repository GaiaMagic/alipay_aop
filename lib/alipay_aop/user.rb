require 'alipay_aop/api'

module AlipayAOP
  class User
    attr_reader :user_id

    def initialize(user_id)
      @user_id = user_id
    end

    def location
      api.user_location(self)
    end


    private

    def api
      AlipayAOP.api
    end
  end

end
