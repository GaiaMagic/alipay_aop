require 'yaml'
require 'json'

module AlipayAOP
  class Menu < BasicData
    extend Forwardable

    def self.load_from_yaml(yaml_string)
      new(YAML::load(yaml_string))
    end

    def initialize(param = {})
      super
    end

    def save!(method = :update)
      if method == :update
        update!
      else
        create!
      end
    end

    private

    def update!
      post_request('alipay.mobile.public.menu.update')
    end

    def create!
      post_request('alipay.mobile.public.menu.add')
    end

    def post_request(method)
      client.request(method, self.serialize)
    end

    def serialize
      @param.to_json
    end
  end
end
