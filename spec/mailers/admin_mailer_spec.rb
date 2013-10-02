require "spec_helper"
include EmailSpec::Helpers
include EmailSpec::Matchers

describe AdminMailer, '#payment_notification' do
  before(:all) do
    campaign = FactoryGirl.create(:campaign)
    @payment = FactoryGirl.create(:payment, campaign: campaign)
    @email = AdminMailer.payment_notification(@payment)
  end

  it 'delivers the snippet to the proper address' do
    expect(@email).to deliver_to(User.where(admin:true).all.map { |user| user.email })
  end

  it "has the correct subject" do
    expect(@email).to have_subject(/Your Crowdhoster project has a new backer!/)
  end

  it "contains the proper copy" do
    expect(@email).to have_body_text(/#{@payment.fullname}/)
  end
end
