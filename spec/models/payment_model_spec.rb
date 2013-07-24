require'spec_helper'

describe Payment do

  it "has a valid factory" do
    expect(FactoryGirl.build(:payment)).to be_valid
  end

  it "is invalid without a full name" do
    expect(Payment.new(fullname: nil)).to have(1).errors_on(:fullname)
  end

  #two errors: one for presence, one for validation
  it "is invalid without an email" do
    expect(Payment.new(email: nil)).to have(2).errors_on(:email)
  end

  it "is invalid without a valid email" do
    payment = Payment.new(
      email: 'test.crowdhoster.com')
    expect(payment).to have(1).errors_on(:email)
  end
end