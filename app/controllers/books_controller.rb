class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:api_create]

  def isbn
    @books = Book.select{|book| book.isbn == params[:isbn]}
    @book_infos = BookInfo.select{|book_info| book_info.isbn == params[:isbn]}
    @data = {books: @books, infos: @book_infos}
    render @data 
  end

  def show
    @book = Book.find(params[:id])
    render json: @book
  end

  def create
    @book = Book.new(book_params)
    respond_to do |format|
      save(@book)
    end
  end

  def borrow
    @book = Book.find(params[:id])
    @book['holder'] = params[:user]
    save(@book)
  end

  def return
    @book = Book.find(params[:id])
    @book['holder'] = 'office@r-learning.co.jp'
    save(@book)
  end

  # GET /books
  def index
    @books = Book.all
  end

  # GET /books/1
  def show
  end

  # GET /books/new
  def new
    @book = Book.new
  end

  # GET /books/1/edit
  def edit
  end

  # POST /books
  def create
    @book = Book.new(book_params)

    unless BookInfo.find_by(isbn: book_params[:isbn])
      from_db = BookInfoFromDB.new(book_params[:isbn])
      if from_db.get_data
        book_info = BookInfo.new(isbn: from_db.isbn, title: from_db.title, author: from_db.author)
        book_info.save!

        image = Image.new(isbn: from_db.isbn)
        image.data = from_db.get_image 
        image.save!
      end
    end

  

    respond_to do |format|
      if @book.save
        format.html { redirect_to @book, notice: 'Book was successfully created.' }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /books/1
  # PATCH/PUT /books/1.json
  def update
    respond_to do |format|
      if @book.update(book_params)
        format.html { redirect_to @book, notice: 'Book was successfully updated.' }
        format.json { render :show, status: :ok, location: @book }
      else
        format.html { render :edit }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /books/1
  # DELETE /books/1.json
  def destroy
    @book.destroy
    respond_to do |format|
      format.html { redirect_to books_url, notice: 'Book was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

#### Actions for API ####

  def api_index
    @books = Book.all
    render json: {books: @books[0]}
  end

  def api_isbn
    @books = Book.select{|book| book.isbn == params[:isbn]}
    @book_infos = BookInfo.select{|book_info| book_info.isbn == params[:isbn]}
    render json: {books: @books, infos: @book_infos}
  end

  def api_show
    @book = Book.find(params[:id])
    render json: @book
  end

  def api_create
    @book = Book.new(book_params)
    respond_to do |format|
      save(@book)
    end
  end

  def api_borrow
    @book = Book.find(params[:id])
    @book['holder'] = params[:user]
    save(@book)
  end

  def api_return
    @book = Book.find(params[:id])
    @book['holder'] = 'office@r-learning.co.jp'
    save(@book)
  end

  def api_search
    book_infos = nil
    case params[:field].to_sym
    when :isbn
      book_infos =  BookInfo.all.select {|book_info| Regexp.compile(params[:q]).match?(book_info.isbn)}
    when :title
      book_infos =  BookInfo.all.select {|book_info| Regexp.compile(params[:q]).match?(book_info.title)}
    when :author
      book_infos =  BookInfo.all.select {|book_info| Regexp.compile(params[:q]).match?(book_info.author)}
    else
      render json: { status: "failed" }
    end

    book_infos_with_status = Array.new
    book_infos.each do |book_info|
      numAll = Book.where(isbn: book_info.isbn).count
      numAvailable = Book.where(isbn: book_info.isbn, holder: "office@r-learning.co.jp").count
      status = if numAvailable > 0
                 1
               elsif numAll > 0
                 2
               else
                 3
               end

      book_infos_with_status.push({
        isbn: book_info.isbn,
        title: book_info.title,
        author: book_info.author,
        status: status
      })
    end
    render json: {status: "success", result: book_infos_with_status }
  end

  def api_list
    books_borrowing = Book.where(holder: params[:user])
    render json: {status: "success", result: books_borrowing}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    def save(book)
      if @book.save
        #format.json { render :show, status: :created, location: @book }
        render json: {status: "success"}
      else
        #format.json { render json: @book.errors, status: :unprocessable_entity }
        render json: {status: "failed"}
      end
    end 

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:isbn, :holder, :registerer, :duedate)
    end
end


class BookInfoFromDB
  require 'rexml/document'
  require 'open-uri'

  NDL_EP = 'http://iss.ndl.go.jp'
  OPENBD_EP = 'http://cover.openbd.jp'
  attr_reader :isbn, :title, :author

  def initialize(isbn)
    @isbn = isbn
  end

  def get_data
    conn = Faraday::Connection.new(NDL_EP) do |b|
      b.use Faraday::Request::UrlEncoded
      b.use Faraday::Adapter::NetHttp
    end

    hash = {isbn: @isbn}

    begin
      res = conn.get '/api/opensearch', hash
      doc = ::REXML::Document.new(res.body)
      @title = doc.elements['rss/channel/item/title'].text
      @author = doc.elements['rss/channel/item/author'].text
    rescue => e
      Rails.logger.debug e.to_s
      return false 
    end
    return true
  end

  def get_image(path = './')
    open(OPENBD_EP + '/' + @isbn + '.jpg') do |img|
      return img.read
    end
  end
end

