class NotificationMailer < ApplicationMailer
  def email_notification
    @notification = params[:notification]

    mail(to: @notification[:user].email, subject: "[EllisCFB] - #{@notification[:subject]}")
  end
end
