class GunplaHistoryCell < Cell::ViewModel
  include Devise::Controllers::Helpers
  def show
    if user_signed_in?
      @histories = current_user.browsing_histories.order(created_at: :desc).includes([:gunpla])
    end
    render
  end
end
