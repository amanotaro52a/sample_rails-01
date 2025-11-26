class WorksController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @works = pagy(Work.includes(:user), limit: 15)
  end

  def new
    @work = Work.new
  end

  def create
    @work = current_user.works.build(work_params)
    if @work.save
      redirect_to works_path, success: "作品の新規作成に成功しました"
    else
      flash.now[:danger] = "作品の新規作成に失敗しました"
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @work = Work.find(params[:id])
    @comment = Comment.new
    @comments = @work.comments.includes(:user).order(created_at: :desc)
  end

  def edit
    @work = current_user.works.find(params[:id])
  end

  def update
    @work = current_user.works.find(params[:id])
    if @work.update(work_params)
      redirect_to work_path(@work), success: "更新しました"
    else
      flash.now[:danger] = "更新できませんでした"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    work = current_user.works.find(params[:id])
    work.destroy!
    redirect_to works_path, success: "作品を削除しました"
  end

  def bookmarks
    @bookmark_works = current_user.bookmark_works.includes(:user).order(created_at: :desc)
  end

  private

  def work_params
    params.require(:work).permit(:title, :body, :image)
  end
end
