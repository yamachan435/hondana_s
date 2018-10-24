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
    stocks.count {|stock| stock.holder == 'office@r-learning.co.jp' }
  end

  def stock_onloan
    stocks.count {|stock| stock.holder != 'office@r-learning.co.jp' }
  end

  def borrowable?
    stock_available > 0
  end

  def returnable?(user)
    stocks.count {|stock| stock.holder == user.email } > 0
  end

  def borrow(user)
    return false unless borrowable?
    stocks.select {|stock| stock.holder == 'office@r-learning.co.jp'}.first.borrow(user)
    return true
  end

  def return(user)
    return false unless returnable?(user)
    stocks.select {|stock| stock.holder == user.email}.first.return
    return true
  end
end
