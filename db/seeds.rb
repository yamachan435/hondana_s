User.create!(name:  "Example User",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar")
Book.create!(isbn: '9784774150017',
             title: 'Ruby official',
             author: 'Masui, Yuichiro')

Stock.create!(book_id: 1,
              holder: 'office@r-learning.co.jp',
              registerer: 'h-tanaka@r-learning.co.jp',
              duedate: '20181025')

