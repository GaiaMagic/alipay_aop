
module AlipayAOP
  class Message

    def self.from_hash(msg)
      params = {}

      case msg['msgType']
      when 'text'
        params.merge!(:text => msg['text']['content'])
      when 'image-text'
        params.merge!(:articles => msg['articles'].map { |article|
                        Article.from_hash(JSON.parse(article))
                      })
      end

      params.merge!(:create_time => msg['createTime'])

      new(msg['toUserId'], msg['msgType'], params)
    end


    attr_accessor :to_user,
                  :type,
                  :create_time,
                  :content,
                  :articles,
                  :create_time

    def initialize(to_user, type, params)
      @to_user = to_user
      @to_user = User.from_id(@to_user) unless @to_user.nil? or
                                               @to_user.is_a? User
      @type = type.intern

      case @type
      when :image_text
        @articles = params[:articles]
      when :text
        @content = params[:content]
      else
        raise 'invalid message type'
      end

      @create_time = params[:create_time] || Time.now
    end


    def to_json
      result = {
        'toUserId'   => @to_user.user_id,
        'msgType'    => @type == :text ? 'text' : 'image-text',
        'createTime' => @create_time.strftime('%Y-%m-%d %H:%m:%S'),
      }

      case @type
      when :text
        result.merge!(:text => { :content => @content })
      when :image_text
        result.merge!(:articles => @articles.map(&:to_json))
      end

      JSON.generate(result)
    end

  end

end
