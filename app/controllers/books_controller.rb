class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]
  protect_from_forgery :except => [:api_create]

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
    render json: @books
  end

  def api_isbn
    @books = Book.select{|book| book.isbn == params[:isbn]}
    render json: @books
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book
      @book = Book.find(params[:id])
    end

    def save(book)
      if @book.save
        format.json { render :show, status: :created, location: @book }
      else
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end 

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_params
      params.require(:book).permit(:isbn, :holder, :registerer, :duedate)
    end
end
