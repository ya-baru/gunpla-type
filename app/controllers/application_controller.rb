class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_params, if: :devise_controller?

  # rescue_from Exception, with: :render_500
  # def render_500(e)
    # ExceptionNotifier.notify_exception(e, env: request.env, data: { message: "error" })
  #   respond_to do |format|
  #     # format.html { render template: 'front/errors/500', layout: 'front/layouts/error', status: 500 }
  #     format.all { render nothing: true, status: 500 }
  #   end
  # end

  rescue_from StandardError, with: :error_500 unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound,
              ActionController::RoutingError,with: :error_404 unless Rails.env.development?

  def error_404
    render body: nil, status: :not_found
  end

  def error_500(e)
    Rails.logger.error e
    Rails.logger.error e.backtrace.join("\n")

    ExceptionNotifier.notify_exception(e, env: request.env, data: { message: "error" })
    render body: nil, status: :internal_server_error
  end

  protected

  def configure_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :profile, :email_confirmation, :avatar])
  end

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  private

  def sign_in_required
    unless user_signed_in?
      flash[:danger] = "アカウント登録もしくはログインしてください。"
      redirect_to new_user_session_url
    end
  end
end
