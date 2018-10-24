class StocksController < ApplicationController

  def new
  end

  def create
    obj_book = Book.obtain(params[:isbn])
    @stock = obj_book.stocks.build 
    @stock.holder = "office@r-learning.co.jp"
    @stock.registerer = current_user.email
    @duedate = nil
    if @stock.save
      obj_book.fetch if obj_book.title == nil
      flash[:success] = "登録が完了しました。"
    else
      flash[:danger] = "登録できませんでした。"
    end
    redirect_to root_path
  end

end
