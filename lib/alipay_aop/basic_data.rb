
module AlipayAOP
  class BasicData
    include ActiveSupport

    attr_accessor :attr, :client

    class << self
      def create(options)
        client.create(path_name, options)
      end

      def path_name
        name.split('::').last.underscore
      end

      def client
        AlipayAOP.client
      end
    end

    def client
      @client || self.class.client
    end

    def initialize(param = {})
      @param = param
    end

  end
end
