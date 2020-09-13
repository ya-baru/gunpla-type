class ApplicationController < ActionController::Base
  # rescue_from Exception, with: :render_500

  # def render_500(e)
  #   ExceptionNotifier.notify_exception(e, env: request.env, data: { message: "error" })
  #   respond_to do |format|
  #     format.html { render template: 'front/errors/500', layout: 'front/layouts/error', status: 500 }
  #     format.all { render nothing: true, status: 500 }
  #   end
  # end

  def after_sign_in_path_for(resource)
    users_show_path(resource)
  end

  private

  def sign_in_required
    redirect_to new_user_session_url unless user_signed_in?
  end
end
