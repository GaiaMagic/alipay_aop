require 'xml'
require 'json'
require 'ostruct'
require 'activesupport'

module AlipayAOP

  refine Hash do
    def to_underscore_ostruct
      os = OpenStruct.new

      each do |k,v|
        v = v.to_underscore_ostruct if Hash === v
        os.send :[]=, k.underscore, v
      end

      os
    end

  end

  class Request < OpenStruct
    class << self
      def from_biz_content(biz_content_string)
        encoded_string = biz_content_string.encode(client.charset,
                                                   :invalid => :replace,
                                                   :undef   => :replace)

        nova = Request.from_hash(Hash.from_xml(encoded_string))

        if nova.respond_to? :user_info
          nova.user_info = JSON.parse(nova.user_info)
        end

        nova
      end

      def from_hash(hash)
        req = new

        hash.each do |k,v|
          v = v.to_underscore_ostruct if Hash === v
          req.send :[]=, k.underscore, v
        end

        req
      end

      def client
        AlipayAOP.client
      end
    end

    attr_accessor :client

    def client
      @client || self.class.client
    end

    def from_user
      return nil unless self.respond_to? :from_user_id
      @from_user ||= User.new(from_user_id)
    end

  end
end
