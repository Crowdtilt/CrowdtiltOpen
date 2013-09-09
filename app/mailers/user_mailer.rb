class UserMailer < ActionMailer::Base
  default from: 'team@crowdhoster.com'

  def payment_confirmation(payment, campaign)
    @settings = Settings.find_by_id(1)
    @payment = payment
    @campaign = campaign
    mail from: "#{@settings.site_name} <#{@settings.reply_to_email}>", reply_to: @settings.reply_to_email, to: @payment.email, subject: "Your confirmation for #{@campaign.name}"
  end
end
