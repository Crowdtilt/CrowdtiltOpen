require'spec_helper'

describe Campaign do

  it "has a valid factory" do
    expect(FactoryGirl.build(:campaign)).to be_valid
  end

  it "is invalid without a name" do
    expect(Campaign.new(name: nil)).to have(1).errors_on(:name)
  end

  it "is invalid without an expiration date" do
    expect(Campaign.new(expiration_date: nil)).to have(1).errors_on(:expiration_date)
  end

  it "is invalid without a min payment amount >= 1" do
    campaign = Campaign.new(
      min_payment_amount: '.99')
    expect(campaign).to have(1).errors_on(:min_payment_amount)
  end

  it "is invalid without a fixed payment amount >= 1" do
    campaign = Campaign.new(
      fixed_payment_amount: '.99')
    expect(campaign).to have(1).errors_on(:fixed_payment_amount)
  end
end