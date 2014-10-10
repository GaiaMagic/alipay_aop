require 'alipay_aop/user'
require 'alipay_aop/media'
require 'alipay_aop/reply'

module AlipayAOP
  class Request
    attr_reader :biz_content_raw,
                :signature,
                :service


    def initialize(post_params)
      @service = post_params['service']
      @biz_content_raw = post_params['biz_content']
      @signature = post_params['sign']
      set_up_content
    end

    def set_up_content
      fields = Hash.from_xml(@biz_content_raw)['XML']

      fields.each do |k,v|
        key = k.intern.underscore

        case key
        when :from_user_id
          define_getter(:from_user, User.from_id v)
        when :create_time
          define_getter(:create_time, Time.at v.to_i)
        when :user_info
          define_getter(:user_info, JSON.parse v)
        when :image
          media = Media.new(v['MediaId'], v['Format'])
          define_getter(:image, media)
        when :text
          define_getter(:text, v['Content'])
        else
          define_getter(key, v)
        end
      end
    end

    def reply
      Reply.new(self)
    end


    private

    def define_getter(name, val)
      self.singleton_class.send(:define_method, name) { val }
    end

  end
end
