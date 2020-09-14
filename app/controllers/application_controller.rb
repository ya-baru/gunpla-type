class ApplicationController < ActionController::Base
  before_action :configure_sign_up_params, if: :devise_controller?

  # rescue_from Exception, with: :render_500
  # def render_500(e)
  #   ExceptionNotifier.notify_exception(e, env: request.env, data: { message: "error" })
  #   respond_to do |format|
  #     format.html { render template: 'front/errors/500', layout: 'front/layouts/error', status: 500 }
  #     format.all { render nothing: true, status: 500 }
  #   end
  # end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  private

  def sign_in_required
    redirect_to signin_url unless user_signed_in?
  end
end
