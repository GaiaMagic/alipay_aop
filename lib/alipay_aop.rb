require 'ostruct'

require 'alipay_aop/version'


module AlipayAOP
  autoload :Message, 'alipay_aop/message'
  autoload :Responder, 'alipay_aop/message'
  autoload :User, 'alipay_aop/user'
  autoload :Article, 'alipay_aop/article'
  autoload :Media, 'alipay_aop/media'
  autoload :Request, 'alipay_aop/request'

  def self.config
    @config ||= self.configure
  end

  def self.configure
    config_file = Rails.root.join("config/alipay_aop.yml")
    @config = if defined? Rails and File.exist?(config_file)
                OpenStruct.new(YAML.load(File.read(config_file))[Rails.env])
              end

    yield @config if block_given?
    @config
  end


  def self.api
    @api ||= Api.new(config.app_id,
                     config.private_key_file,
                     config.public_key_file)
  end
end
