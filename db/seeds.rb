User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar")

Book.create!(title: "Ruby公式資格教科書 : Ruby技術者認定試験Silver/Gold対応 : A Programmer's Best Friend",
             author: "増井雄一郎, 小川伸一郎, 藁谷修一, 川尻剛, 牧俊男 著,Rubyアソシエーション, CTCテクノロジー(株) 監修, ",
             isbn: "9784774150017")

Book.create!(title: "メタプログラミングRuby",
             author: "Paolo Perrotta 著,角征典 訳,Perrotta, Paolo,角, 征典, ",
             isbn: "9784873117430")

Stock.create!(book_id: 1,
              holder_id: 1,
              registerer_id: 1,
              duedate: 4.days.ago)

Stock.create!(book_id: 1,
              holder_id: nil,
              registerer_id: 1,
              duedate: nil)

Stock.create!(book_id: 1,
              holder_id: 1,
              registerer_id: 1,
              duedate: 2.days.from_now)

Stock.create!(book_id: 1,
              holder_id: 1,
              registerer_id: 1,
              duedate: 1.day.ago)


Stock.create!(book_id: 2,
              holder_id: 1,
              registerer_id: 1,
              duedate: 10.days.from_now)

Notification.create!(user_id: 1,
                     content: "資格本の返却期限が過ぎています。",
                     link: "books/1")


