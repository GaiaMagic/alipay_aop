require 'rest-client'

require 'json'

require_relative 'server_key'
require_relative 'client_key'
require_relative 'support'


module AlipayAOP
  ALIPAY_GATEWAY = 'https://openapi.alipay.com/gateway.do'

  class Client
    include Support

    attr_accessor :app_id,
                  :charset,
                  :sign_type,
                  :version,
                  :client_key,
                  :server_key

    def initialize(params)
      settings = {
        :charset   => :GBK,
        :sign_type => :RSA,
        :version   => '1.0'
      }.merge(params)

      settings.each do |k, v|
        instance_variable_set("@#{k.to_s}", v)
      end

      validate_client
    end


    def request(method, body = {})
      biz_content = body.to_json.to_s
      biz_content = biz_content.encode(@charset,
                                       :invalid => :replace,
                                       :undef   => :replace)

      request_params = basic_prams.merge {
        :method      => method
        :biz_content => biz_content,
        :sign        => sign_content(method, biz_content)
      }

      response = RestClient.post(URI::encode(ALIPAY_GATEWAY),
                                 request_params)

      response
    end


    private

    def basic_params
      {
        :app_id    => @app_id,
        :charset   => @charset,
        :version   => @version,
        :sign_type => @sign_type,
        :timestamp => timestamp
      }
    end

    def timestamp
      Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end

    def sign_content(method, biz_content)
      params = basic_params.merge {
        :biz_content => biz_content,
        :method => method,
      }

      message = params.to_a.sort.map { |(k,v)| "#{k.to_s}=#{v.to_s}" }
                                .join('&')

      @client_key.sign(message)
    end

    def validate_client
      [:app_id,
       :charset,
       :sign_type,
       :version,
       :client_key,
       :server_key
      ].all {|x| instance_variable_present?(x) } or
        raise 'Some parameter(s) is required but not supplied.'
    end


  end
end
