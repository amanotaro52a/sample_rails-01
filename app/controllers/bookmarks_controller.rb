class BookmarksController < ApplicationController
  def create
    @work = Work.find(params[:work_id])
    current_user.bookmark(@work)
  end

  def destroy
    @work = current_user.bookmarks.find(params[:id]).work
    current_user.unbookmark(@work)
  end
end
