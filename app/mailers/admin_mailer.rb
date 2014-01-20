class AdminMailer < ActionMailer::Base
  layout 'default_mailer'
  default from: "payments@crowdhoster.com"

  helper :campaigns

  def payment_notification(payment_id)
    recipients = User
      .where(admin: true, wants_admin_payment_notification: true)
      .all
      .map { |user| user.email }

    if (recipients.length > 0)
      begin
        @settings = Settings.first
        @payment = Payment.find(payment_id)
      rescue ActiveRecord::RecordNotFound
        logger.error "Email failed - could not find Payment #{payment_id}"
      end
      @campaign = @payment.campaign
      @reward = @payment.reward
      mail(
        to: recipients,
        subject: "New backer for \"#{@campaign.name}\""
      )
    end
  end

end
