class NotificationsController < ApplicationController
  def make
    Notification.make_due_notifications_today
    flash[:success] = "処理が完了しました。"
    redirect_to root_path
  end

  def destroy
    Notification.find(params[:id]).destroy
    flash[:success] = "お知らせを削除しました。"
    redirect_to root_path
  end
end
