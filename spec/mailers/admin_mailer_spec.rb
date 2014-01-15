require "spec_helper"
include EmailSpec::Helpers
include EmailSpec::Matchers

describe AdminMailer, '#payment_notification' do
  before(:each) do
    FactoryGirl.create(:settings)
    FactoryGirl.create(:user, :admin)
    @campaign = FactoryGirl.create(:campaign)
    @payment = FactoryGirl.create(:payment, campaign: @campaign)
    @email = AdminMailer.payment_notification(@payment.id)
  end

  it 'delivers the snippet to the proper address' do
    expect(@email).to deliver_to(User.where(admin:true).all.map { |user| user.email })
  end

  it "has the correct subject" do
    expect(@email).to have_subject(/New backer for \"#{@campaign.name}\"/)
  end

  it "contains the proper copy" do
    expect(@email).to have_body_text(/#{@payment.fullname}/)
  end
end
