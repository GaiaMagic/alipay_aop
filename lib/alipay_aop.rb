require "alipay_aop/version"

module AlipayAOP
  autoload :Client, 'alipay_aop/client'
  autoload :Menu,   'alipay_aop/menu'

  Error = Class.new(StandardError)

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.client
    @client ||= Client.new
  end

  def self.configure(&block)
    @client.configure(&block)
  end
end
