class StocksController < ApplicationController

  def new
  end

  def create
    obj_book = Book.obtain(params[:isbn])
    @stock = obj_book.stocks.build 
    @stock.registerer = current_user
    @duedate = nil
    logger.debug @stock.inspect
    if @stock.save
      #obj_book.fetch if obj_book.title == nil
      obj_book.fetch
      flash[:success] = "登録が完了しました。"
      redirect_to obj_book
    else
      flash[:danger] = "登録できませんでした。"
      redirect_to rental_path
    end
  end

end
