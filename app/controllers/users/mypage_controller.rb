class Users::MypageController < ApplicationController
  before_action :setup_user

  def show
    @reviews = @user.reviews.
      page(params[:page]).
      per(LIST_PAGINATE_COUNT).
      # includes([images_attachments: :blob]).
      order(id: :desc)
    @breadcrumb = :mypage
    @title = "マイページ"
  end

  def like_reviews
    @reviews = @user.like_reviews.
      page(params[:page]).
      per(LIST_PAGINATE_COUNT).
      # includes([images_attachments: :blob]).
      order(id: :desc)
    @breadcrumb = :like_reviews
    @title = "いいね！レビューリスト"
    render :show
  end

  def favorite_gunplas
    @gunplas = @user.favorite_gunplas.
      page(params[:page]).
      per(LIST_PAGINATE_COUNT).
      includes([:category, :reviews]).
      # includes([:category], reviews: [images_attachments: :blob]).
      order(id: :desc).decorate
    @breadcrumb = :favorite_gunplas
    @title = "お気に入りガンプラリスト"
    render :show
  end

  def following
    @follwing = @user.following.
      page(params[:page]).
      per(LIST_PAGINATE_COUNT).
      includes([avatar_attachment: :blob]).
      order(id: :desc).decorate
    @breadcrumb = :following
    @title = "フォローリスト"
    render :show
  end

  def followers
    @followers = @user.followers.
      page(params[:page]).
      per(LIST_PAGINATE_COUNT).
      includes([avatar_attachment: :blob]).
      order(id: :desc).decorate
    @breadcrumb = :followers
    @title = "フォロワーリスト"
    render :show
  end

  private

  def setup_user
    @user = User.find_by(id: params[:id])
    return redirect_to root_path if @user.nil?
  end
end
