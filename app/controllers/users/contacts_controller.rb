class Users::ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def confirm
    return redirect_to new_user_contact_url if params[:contact].blank?

    @contact = Contact.new(contact_params)
    render :new unless @contact.valid?
  end

  def create
    @contact = Contact.new(contact_params)
    return render :new unless @contact.save
    return render :new if params[:back].present?

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
