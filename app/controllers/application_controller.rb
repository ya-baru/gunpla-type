class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_params, if: :devise_controller?

  unless Rails.env.development?
    rescue_from StandardError, with: :error_500
    rescue_from ActiveRecord::RecordNotFound,
                ActionController::RoutingError, with: :error_404
  end

  def error_404
    render body: nil, status: :not_found
  end

  def error_500(e)
    Rails.logger.error e
    Rails.logger.error e.backtrace.join("\n")

    ExceptionNotifier.notify_exception(e, env: request.env, data: { message: "error" })
    render body: nil, status: :internal_server_error
  end

  def notice_slack(message)
    notifier = Slack::Notifier.new(Rails.application.credentials.slack[:secret_url])
    notifier.ping(message)
  end

  protected

  def configure_permitted_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :profile, :email_confirmation, :avatar])
  end

  private

  def after_sign_in_path_for(resource)
    if resource.admin_flg?
      rails_admin_path
    else
      mypage_path(resource)
    end
  end

  def login_user
    if user_signed_in?
      flash[:danger] = I18n.t("devise.failure.already_authenticated")
      redirect_to mypage_url(current_user)
    end
  end
end
