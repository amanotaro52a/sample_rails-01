class WorksController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Work.ransack(params[:q])
    @pagy, @works = pagy(@q.result(distinct: true).includes(:user).order(created_at: :desc), limit: 15)
  end

  def new
    @work = Work.new
  end

  def create
    @work = current_user.works.build(work_params)
    if @work.save
      redirect_to works_path, success: t("defaults.flash_message.work_created")
    else
      flash.now[:danger] = t("defaults.flash_message.work_not_created")
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
      redirect_to work_path(@work), success: t("defaults.flash_message.work_update")
    else
      flash.now[:danger] = t("defaults.flash_message.work_not_update")
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    work = current_user.works.find(params[:id])
    work.destroy!
    redirect_to works_path, success: t("defaults.flash_message.work_destroy")
  end

  def bookmarks
    @q = current_user.bookmark_works.ransack(params[:q])
    @pagy, @bookmark_works = pagy(@q.result(distinct: true).includes(:user).order(created_at: :desc), limit: 15)
  end

  private

  def work_params
    params.require(:work).permit(:title, :body, :image)
  end
end
