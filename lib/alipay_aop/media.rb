
module AlipayAOP
  class Media < Struct.new(:media_id, :format)
    def content
      @content ||= fetch_media
    end


    private

    def fetch_media
      AlipayAOP.api.download_media(self)
    end
  end
end
