class Users::ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update destroy)
  before_action :set_review, only: %i(new create)

  def show
    @review = Review.find(params[:id])
    @gunpla = @review.gunpla
  end

  def new; end

  def create
    return render :new unless @review.save

    redirect_to gunpla_url(@gunpla), notice: "『#{@gunpla.name}』のレビューが完了しました。"
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:title, :content, :rate, :gunpla_id, images: [])
  end

  def set_review
    @gunpla = Gunpla.find(params[:gunpla_id])
    if Review.exists?(user_id: current_user.id, gunpla_id: @gunpla.id)
      redirect_to gunpla_path(@gunpla), alert: "このガンプラはレビュー済みです"
      return
    end
    @review = current_user.reviews.build(gunpla_id: @gunpla.id).decorate
  end
end
