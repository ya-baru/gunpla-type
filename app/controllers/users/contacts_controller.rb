class Users::ContactsController < ApplicationController
  def new
    @contact = Contact.new(session[:contact] || {})
    session[:contact] = nil
  end

  def confirm
    @contact = Contact.new(contact_params)

    unless @contact.valid?
      session[:contact] = contact_params
      redirect_to new_user_contact_url, flash: { danger: @contact.errors.full_messages.join(",") }
    end
  end

  def confirm_back
    session[:contact] = contact_params
    redirect_to new_user_contact_url
  end

  def create
    @contact = Contact.new(contact_params)
    return render :new unless @contact.save

    Users::ContactMailer.contact_mail(@contact).deliver_now
    slack_info
    redirect_to root_path, notice: "お問い合わせを受け付けました"
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end

  def slack_info
    message = "新しい問い合わせがあります。#{Rails.application.credentials.gmail[:link]}"
    notice_slack(message)
  end
end
