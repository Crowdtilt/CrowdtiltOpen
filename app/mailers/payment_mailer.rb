class PaymentMailer < ActionMailer::Base
  default from: "payments@crowdhoster.com"

  def admin_notification(payment)
    @payment = payment
    mail(
      to: User.where(admin:true).all.map { |user| user.email },
      subject: 'Your Crowdhoster project has a new backer!'
    )
  end
end
