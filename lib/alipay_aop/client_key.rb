require 'openssl'


module AlipayAOP
  class ClientKey
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
      @public_key.sign(@digest)
    end

  end
end
