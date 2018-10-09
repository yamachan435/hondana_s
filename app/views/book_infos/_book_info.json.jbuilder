json.extract! book_info, :id, :isbn, :title, :author, :created_at, :updated_at
json.url book_info_url(book_info, format: :json)
