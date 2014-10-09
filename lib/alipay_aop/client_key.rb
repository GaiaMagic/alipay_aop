require 'openssl'


module AlipayAOP
  class ClientKey
    attr_accessor :public_key,
                  :private_key,
                  :digest

    def self.create_from_file(private_key_file)
      Keypair.new(File.read(private_key_file))
    end

    def initialize(private_key)
      @private_key = OpenSSL::PKey::RSA.new(private_key)
      @public_key = @private_key.public_key
      @digest = OpenSSL::Digest::SHA1.new
    end


    def sign(message)
      signed = @private_key.sign(@digest, message)
      signed_plain = Base64.encode64(signed).gsub("\n", '')

      signed_plain
    end

    def verify(message, signature)
      signature_decoded = Base64.decode64(signature)
      @public_key.verify(@digest, signature_decoded, message)
    end

  end
end
