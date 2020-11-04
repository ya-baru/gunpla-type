class Users::CommentsController < ApplicationController
  prepend_before_action :authenticate_user!

  def create
    @review = Review.find(params[:review_id])
    @gunpla = @review.gunpla
    @comment = current_user.comments.build(comment_params).decorate
    return redirect_to request.referer, alert: "コメント送信に失敗しました" unless @comment.save

    @comment.save_notification_comment(current_user, @review.id, @review.user_id)
    redirect_to request.referer, notice: "コメント送信が完了しました"
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy
    redirect_to request.referer, notice: "コメントを削除しました"
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :review_id)
  end
end
