require 'openssl'


module AlipayAOP
  class ServerKey
    def self.create_from_file(public_key_file)
      Keypair.new(File.read(public_key_file))
    end

    def initialize(public_key)
      @public_key = OpenSSL::PKey::RSA.new(public_key)
      @digest = OpenSSL::Digest::SHA1.new
    end

    def verify(message, signature)
      signature_decoded = Base64.decode64(signature)
      @public_key.verify(@digest, signature_decoded, message)
    end

  end
end
