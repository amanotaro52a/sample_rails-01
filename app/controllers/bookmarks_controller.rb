class BookmarksController < ApplicationController
  def create
    work = Work.find(params[:work_id])
    current_user.bookmark(work)
    redirect_to work_path, success: "お気に入りに登録しました"
  end

  def destroy
    work = current_user.bookmarks.find(params[:id]).work
    current_user.unbookmark(work)
    redirect_to works_path, success: "お気に入りから外しました", status: :see_other
  end
end
