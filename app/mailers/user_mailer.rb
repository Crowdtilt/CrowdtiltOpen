class UserMailer < ActionMailer::Base
  layout 'default_mailer'

  helper :campaigns

  def payment_confirmation(payment, campaign)
    @settings = Settings.first
    @payment = payment
    @campaign = campaign
    mail from: "#{@settings.site_name} <#{@settings.reply_to_email}>", reply_to: @settings.reply_to_email, to: @payment.email, subject: "Your confirmation for #{@campaign.name}"
  end

end
