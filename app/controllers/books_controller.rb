class BooksController < ApplicationController
  before_action :logged_in_user

  def find
    @book = Book.find_by(isbn: params[:isbn])
    redirect_to @book          
  end

  def show
    @book = Book.find(params[:id])
    @stocks = @book.stocks
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
      redirect_to rental_path
    end
  end
end
