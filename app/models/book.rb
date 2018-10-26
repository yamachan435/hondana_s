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

  def self.search(type, query)
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
end
