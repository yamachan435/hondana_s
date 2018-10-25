require 'faraday'
require 'rexml/document'
require 'open-uri'

module IsbnInfoService 
  NDL_EP = 'http://iss.ndl.go.jp'
  OPENBD_EP = 'http://cover.openbd.jp'

  def fetch_info 
    conn = Faraday::Connection.new(NDL_EP) do |b|
      b.use Faraday::Request::UrlEncoded
      b.use Faraday::Adapter::NetHttp
    end

    hash = {isbn: isbn}
    
    begin
      res = conn.get '/api/opensearch', hash
      doc = REXML::Document.new(res.body)
      update_attribute(:title, doc.elements['rss/channel/item/title'].text)
      update_attribute(:author, doc.elements['rss/channel/item/author'].text)
    rescue
      return false
    end
    return true
  end

  def fetch_image(path = './')
   open(OPENBD_EP + '/' + (isbn.to_s) + '.jpg') do |img|
     File.open(path + id.to_s + '.jpg', 'wb') do |file|
       file.puts img.read
     end
   end
  end
end

# book_info = BookInfo.new(gets.chomp)
# if book_info.get_data 
#   p book_info.title
#   p book_info.author
# else
#   p "dame"
# end
# book_info.get_image("./app/assets/images/covers/")

