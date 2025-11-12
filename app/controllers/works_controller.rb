class WorksController < ApplicationController
  before_action :authenticate_user!

  def index
    @works = Work.includes(:user)
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

  private

  def work_params
    params.require(:work).permit(:title, :body)
  end
end
