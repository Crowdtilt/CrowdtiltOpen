require "spec_helper"
include EmailSpec::Helpers
include EmailSpec::Matchers

describe PaymentMailer, '#send_mailer' do
  before(:all) do
    User.find_by_email('admin_test@crowdhoster.com').destroy
    FactoryGirl.create(:user, :admin)
    campaign = FactoryGirl.create(:campaign)
    @payment = FactoryGirl.create(:payment, campaign: campaign)
    @email = PaymentMailer.send_mailer(@payment)
  end

  it 'delivers the snippet to the proper address' do
    expect(@email).to deliver_to(User.where(admin: true).first.email)
  end

  it "has the correct subject" do
    expect(@email).to have_subject(/Your project has a new backer!/)
  end

  it "contains the proper copy" do
    expect(@email).to have_body_text(/#{@payment.fullname}/)
  end
end
