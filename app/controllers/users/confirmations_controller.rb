# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # def new
  #   super
  # end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?
    if successfully_sent?(resource)
      redirect_to account_confirmation_mail_sent_url
    else
      render :new
      # redirect_to confirmation_send_url, flash: { error: resource.errors.full_messages }
    end
  end

  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
