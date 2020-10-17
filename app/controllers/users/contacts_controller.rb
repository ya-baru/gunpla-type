class Users::ContactsController < ApplicationController
  include SlackNotice

  def new
    @contact = Contact.new.decorate
  end

  def confirm
    return redirect_to new_user_contact_url if params[:contact].blank?

    @contact = Contact.new(contact_params).decorate
    render :new unless @contact.valid?
  end

  def create
    @contact = Contact.new(contact_params).decorate
    return render :new unless @contact.save
    return render :new if params[:back].present?

    Users::ContactMailer.contact_mail(@contact).deliver_now
    contacts_slack
    redirect_to root_path, notice: "お問い合わせを受け付けました"
  end

  private

  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end
end
