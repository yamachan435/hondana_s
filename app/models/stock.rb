class Stock < ApplicationRecord
  belongs_to :book
  belongs_to :holder, class_name: "User", optional: true
  belongs_to :registerer, class_name: "User", optional: true

  def borrow(user)
    update_attribute(:holder, user)
    update_attribute(:duedate, Date.today.weeks_since(2))
  end

  def return
    update_attribute(:holder, nil)
  end
end
