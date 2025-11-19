class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to work_path(comment.work), success: "コメントを作成しました"
    else
      redirect_to work_path(comment.work), danger: "コメントを作成できませんでした"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(work_id: params[:work_id])
  end
end
