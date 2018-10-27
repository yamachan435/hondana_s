class Stock < ApplicationRecord
  DUE_VALID = 1
  DUE_NEAR = 2
  DUE_EXPIRED = 3

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

  def due
    nil if duedate.nil?
    if duedate < Date.today
      DUE_EXPIRED
    elsif duedate < 3.days.from_now
      DUE_NEAR
    else
      DUE_VALID
    end
  end
end
