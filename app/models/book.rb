class Book < ApplicationRecord
  validates :isbn, presence: true, uniqueness: true, length: { is: 13}
  has_many :stocks

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

  def return
    return false unless returnable?
    stocks.select {|stock| stock.holder == user.email}.first.return
    return true
  end
end
