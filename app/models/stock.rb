class Stock < ApplicationRecord
  belongs_to :book

  def borrow(user)
    update_attribute(:holder, user.email)
  end

  def return
    update_attribute(:holder, "office@r-learning.co.jp")
  end
end
