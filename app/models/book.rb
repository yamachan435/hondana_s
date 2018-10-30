class Book < ApplicationRecord
  validates :isbn, presence: true, uniqueness: true, length: { is: 13}
  has_many :stocks

  include IsbnInfoService

  def self.obtain(isbn)
    if Book.exists?(isbn: isbn)
      Book.find_by(isbn: isbn)
    else
      Book.new(isbn: isbn).save
      Book.last
    end
  end

      

  def stock_all
    stocks.size
  end

  def stock_available
    stocks.count {|stock| stock.holder.nil? }
  end

  def stock_onloan
    stocks.count {|stock| !stock.holder.nil? }
  end

  def borrowable?
    stock_available > 0
  end

  def returnable?(user)
    stocks.count {|stock| stock.holder == user } > 0
  end

  def borrow(user)
    return false unless borrowable?
    stocks.select {|stock| stock.holder.nil? }.first.borrow(user)
    return true
  end

  def return(user)
    return false unless returnable?(user)
    stocks.select {|stock| stock.holder == user }.first.return
    return true
  end

  def fetch
    fetch_info
    fetch_image("./app/assets/images/covers/")
  end

    NDL_EP = 'http://iss.ndl.go.jp'
    NDL_TYPE_HASH = {isbn: 'isbn', title: 'title', author: 'creator'}

  class << self
    def search(type, query)
      case query
      when ""
        raise
      when nil
        raise
      else
        reg = Regexp.compile(".*" + query + ".*")
      end

      case type
      when :isbn
        Book.all.select {|book| reg.match?(book.isbn) }
      when :title
        Book.all.select {|book| reg.match?(book.title) }
      when :author
        Book.all.select {|book| reg.match?(book.author) }
      else
        raise
      end
    end

    def new_search_array(type, query)

      conn = Faraday::Connection.new(NDL_EP) do |b|
        b.use Faraday::Request::UrlEncoded
        b.use Faraday::Adapter::NetHttp
      end
    
      hash = {metiatype: "1", NDL_TYPE_HASH[type].to_sym => query.tr("　"," ")}
        res = conn.get '/api/opensearch', hash
        doc = REXML::Document.new(res.body)
   
      i = 1
      search_array = Array.new
      until (doc.elements["rss/channel/item[#{i}]"].nil?) do
        elm = doc.elements["rss/channel/item[#{i}]"]
        unless elm.elements["dc:identifier[@xsi:type='dcndl:ISBN']"].nil?
          isbn = elm.elements["dc:identifier[@xsi:type='dcndl:ISBN']"].text
          title = elm.elements["title"].nil? ? "" : elm.elements["title"].text
          author = elm.elements["author"].nil? ? "" : elm.elements["author"].text
          
          book = Book.new
          book.isbn = isbn
          book.title = title
          book.author = author
          search_array.push(book)
        end
        i += 1
      end

      search_array.map! do |book|
        Book.all.find_by(isbn: book.isbn) || book
      end
      search_array.sort_by! do |book|
        if book.id.nil?
          3
        elsif !book.borrowable?
          2
        else
          1
        end
      end

      p search_array
      return search_array 
    end
  end
end
