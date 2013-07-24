require'spec_helper'

describe Settings do

  it "has a valid factory" do
    expect(FactoryGirl.build(:settings)).to be_valid
  end

  it "is invalid without a site name" do
    expect(Settings.new(site_name: nil)).to have(1).errors_on(:site_name)
  end

  #two errors: one for presence, one for validation
  it "is invalid without a reply to email" do
    expect(Settings.new(reply_to_email: nil)).to have(2).errors_on(:reply_to_email)
  end

  it "is invalid without a valid reply to email" do
    settings = Settings.new(
      reply_to_email: 'test.crowdhoster.com')
    expect(settings).to have(1).errors_on(:reply_to_email)
  end
end