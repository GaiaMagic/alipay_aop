require 'openssl'
require 'rest_client'
require 'ostruct'

module AlipayAop
  class Client
    attr_reader :base

    def initialize(app_id, base, private_key_file, public_key_file)
      @app_id = app_id
      @base = base

      @alipay_key = OpenSSL::PKey::RSA.new(File.read(public_key_file))
      @private_key = OpenSSL::PKey::RSA.new(File.read(private_key_file))
      @public_key  = @private_key.public_key

      @digest = OpenSSL::Digest::SHA1.new
    end


    def request(service, content)
      parameters = basic_params
      parameters.merge!(:biz_content => content,
                        :sign => sign(content),
                        :method => service)
      resp = RestClient.post(@base, parameters)
      raise "request failed, response code #{resp.code}" unless resp.code == 200
      json_resp = JSON.parse(resp.body)

      OpenStruct.new(json_resp["#{service.gsub('.', '_')}_response"])
    end

    def basic_params
      {
        :app_id => @app_id,
        :charset => 'GBK',
        :timestamp => Time.now.strftime('%Y-%m-%d %H:%m:%S'),
        :version => '1.0'
        # missing: method, biz_content, sign
      }
    end
  end
end
