json.extract! book, :id, :title, :isbn, :author_id, :language, :description, :created_at, :updated_at
json.url book_url(book, format: :json)
