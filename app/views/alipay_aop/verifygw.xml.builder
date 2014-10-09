
xml.instruct! :xml, :version => '1.0', :encoding => 'GBK'
xml.alipay do
  resp = xml.response do
    xml.success true
    xml.biz_content client.client_key.public_key
  end

  xml.sign client.client_key.sign(resp.to_s)
  xml.sign_type "RSA"
end
