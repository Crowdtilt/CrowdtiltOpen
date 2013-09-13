class PaymentMailer < ActionMailer::Base
  default from: "payments@crowdhoster.com"

  def send_mailer(payment)
    @payment = payment
    mail(
      to: User.where(admin: true).first.email,
      subject: 'Crowdhoster: Your project has a new backer!'
    )
  end
end
