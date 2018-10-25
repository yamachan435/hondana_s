class BooksController < ApplicationController
  before_action :logged_in_user

  def find
    begin
      @book = Book.find_by(isbn: params[:isbn])
      redirect_to @book          
    rescue => e
      logger.error e
      flash[:danger] = "該当の本が見つけられません。\nコードが誤っているか、登録されていない本です。"
      redirect_to rental_path
    end
  end

  def show
    begin
      @book = Book.find(params[:id])
      @stocks = @book.stocks
    rescue => e
      logger.error e
      flash[:danger] = "該当の本が見つけられません。\nコードが誤っているか、登録されていない本です。"
      redirect_to rental_path
    end
  end

  def update
    @book = Book.find(params[:id])
    case params[:operation].to_sym
    when :borrow
      if @book.borrow(current_user)
        flash[:success] = "貸出処理が完了しました。"
      else
        flash[:danger] = "その本は借りられません！"
      end 
    when :return
      if @book.return(current_user)
        flash[:success] = "返却処理が完了しました。"
      else
        flash[:danger] = "その本は返せません！"
      end 
    end
    redirect_to rental_path
  end
  
  def search
  end

  def result
    begin
      @books = Book.search(params[:t].to_sym, params[:q])
    rescue => e
      logger.error e.message
      flash[:danger] = "検索パラメータが不正です。"
      redirect_to books_search_path
    end
  end

end
