class ResetPasswordEmail < ApplicationService
  def initialize(user)
    @user = user
  end

  def call
    # create reset token
    @user.update!(reset_token: SecureRandom.uuid)

    notification = {
      user: @user,
      subject: 'Password Reset',
      body: 'Follow the link below to reset your password. This link will expire in 10 minutes.',
      url: "https://elliscfb.com/reset-password/#{@user.reset_token}"
    }

    # send email
    NotificationMailer.with(notification: notification).email_notification.deliver_later
  end
end
