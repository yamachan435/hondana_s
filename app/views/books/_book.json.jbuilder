json.extract! book, :id, :isbn, :holder, :registerer, :duedate, :created_at, :updated_at
json.url book_url(book, format: :json)
