class ApplicationDecorator < Draper::Decorator
  def form_error_message(content)
    h.render "users/shared/error_messages", errors: object.errors, error_msg: content
  end
end
