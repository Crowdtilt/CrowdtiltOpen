class AdminMailer < ActionMailer::Base
  layout 'default_mailer'
  default from: "payments@crowdhoster.com"

  def payment_notification(payment_id)
    @settings = Settings.find_by_id(1)
    @payment = Payment.find(payment_id)
  rescue ActiveRecord::RecordNotFound
    logger.error "Email failed - could not find Payment #{payment_id}"
  else
    @campaign = @payment.campaign
    @reward = @payment.reward
    mail(
      to: User.where(admin:true).all.map { |user| user.email },
      subject: "New backer for \"#{@campaign.name}\""
    )
  end
end
