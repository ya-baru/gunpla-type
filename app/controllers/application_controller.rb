class ApplicationController < ActionController::Base
  rescue_from Exception, with: :render_500

  def hello
    render html: "hello!world!!"
  end

  def render_500(e)
    ExceptionNotifier.notify_exception(e, env: request.env, data: {message: "error"})
    respond_to do |format|
      format.html { render template: 'front/errors/500', layout: 'front/layouts/error', status: 500 }
      format.all { render nothing: true, status: 500 }
    end
  end
end
