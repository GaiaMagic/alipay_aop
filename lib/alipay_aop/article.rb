require 'json'


module AlipayAOP
  class Article
    attr_accessor :attrs

    # allowed attrs:
    #  - title
    #  - desc
    #  - iamge_url
    #  - url
    #  - action_name
    #  - auth_type
    def initialize(attrs)
      @attrs = attrs.symbolize_keys
      if @attrs[:title].nil? and @attrs[:desc].nil? and @attrs[:image_url].nil?
        raise 'title, desc, and image_url cannot be nil at the same time'
      end
    end

    def to_json
      camelcased = @attrs.inject({}) do |acc, (k, v)|
        acc.merge(k.camelcase => v)
      end

      JSON.generate(camelcased)
    end
  end

end
