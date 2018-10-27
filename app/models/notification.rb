class Notification < ApplicationRecord
  belongs_to :user

  class << self
    def make_due_notifications_today
      Stock.where(duedate: Date.today - 1).each do |stock|
        notification = Notification.new(user: stock.holder,
                         content: %|"#{stock.book.title}"の返却期限が過ぎています！|,
                         link: "/books/#{stock.book.id}")
        notification.save!
      end
      Stock.where(duedate: Date.today - 4).each do |stock|
        notification = Notification.new(user: stock.holder,
                         content: %|"#{stock.book.title}"の返却期限が迫っています！|,
                         link: "/books/#{stock.book.id}")
        notification.save!
      end
    end

    def make_arrival_notifications(book)
      User.all.each do |user|
        Notification.new(user: user,
                         content: %|"#{book.title}"が本棚に追加されました！|,
                         link: "/books/#{book.id}").save!
      end 
    end
  end

        
end
