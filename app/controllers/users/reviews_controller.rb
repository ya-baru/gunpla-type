class Users::ReviewsController < ApplicationController
  prepend_before_action :authenticate_user!, only: %i(new create edit update destroy upload_image)
  before_action :correct_user?, only: %i(edit update destroy)
  before_action :reviewed_user?, only: %i(new create)
  before_action :set_review, only: %i(show edit update destroy)

  def show
    @gunpla = @review.gunpla
    @comment = current_user.comments.build(review_id: @review.id).decorate if signed_in?
    @comments = @review.comments.includes([user: [avatar_attachment: :blob]]).order(id: :desc).decorate
  end

  def new
    @review = current_user.reviews.build(gunpla_id: @gunpla.id).decorate
  end

  def create
    @review = current_user.reviews.build(review_params).decorate
    return render :new unless @review.save

    @review.create_notification_review(current_user, @gunpla.id)
    redirect_to review_url(@review), notice: "『#{@gunpla.name}』のレビューが完了しました"
  end

  def edit; end

  def update
    @review.images.detach
    return render :edit unless @review.update(review_params)

    redirect_to review_url(@review), notice: "『#{@review.gunpla_name}』のレビュー内容を編集しました"
  end

  def destroy
    @review.destroy
    redirect_to gunpla_url(@review.gunpla), notice: "『#{@review.gunpla_name}』のレビューを削除しました"
  end

  def upload_image
    @image_blob = create_blob(params[:image])
    respond_to do |format|
      format.json { @image_blob.id }
    end
  end

  private

  def review_params
    params.require(:review).permit(:title, :content, :rate, :gunpla_id).merge(images: uploaded_images)
  end

  def uploaded_images
    params[:review][:images].map { |id| ActiveStorage::Blob.find(id) } if params[:review][:images]
  end

  def create_blob(uploading_file)
    ActiveStorage::Blob.create_after_upload!(
      io: uploading_file.open,
      filename: uploading_file.original_filename,
      content_type: uploading_file.content_type
    )
  end

  def reviewed_user?
    @gunpla = Gunpla.find(params[:gunpla_id])
    if Review.exists?(user_id: current_user.id, gunpla_id: @gunpla.id)
      redirect_to gunpla_url(@gunpla), alert: "『#{@gunpla.name}』はレビュー済みです"
      return
    end
  end

  def correct_user?
    if current_user.reviews.find_by(id: params[:id]).blank?
      redirect_to gunplas_url, alert: "レビューしたガンプラではありません"
    end
  end

  def set_review
    @review = Review.with_attached_images.find(params[:id]).decorate
  end
end
