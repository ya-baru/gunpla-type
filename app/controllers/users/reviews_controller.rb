class Users::ReviewsController < ApplicationController
  before_action :authenticate_user!, only: %i(new create edit update)

  def show
    @review = Review.find(params[:id])
    @gunpla = @review.gunpla
  end

  def new
    @gunpla = Gunpla.find(params[:gunpla_id])
    @review = current_user.reviews.build(gunpla_id: @gunpla.id).decorate
  end

  def create
    @gunpla = Gunpla.find(params[:gunpla_id])
    @review = current_user.reviews.build(review_params).decorate
    @review.images.attach(params[:review][:images])

    if @review.save
      flash[:notice] = "投稿が完了しました。"
      redirect_to gunpla_url(@gunpla)
    else
      render "new"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def review_params
    params.require(:review).permit(:title, :content, :gunpla_id)
  end
end
