require'spec_helper'

describe User do

  it "has a valid factory" do
    expect(FactoryGirl.build(:user)).to be_valid
  end

  it "is invalid without a fullname" do
    expect(User.new(fullname: nil)).to have(1).errors_on(:fullname)
  end

  it "is invalid without an email" do
    expect(User.new(email: nil)).to have(1).errors_on(:email)
  end

  it "is invalid without a password" do
    expect(User.new(password: nil)).to have(1).errors_on(:password)
  end

  it "is invalid without a matching password_confirmation" do
    user = User.new(
      fullname: 'Crowdhoster Tester',
      email: 'test@crowdhoster.com',
      password: 'testdsfsPass',
      password_confirmation: 'testPass')
    expect(user).to have(1).errors_on(:password)
  end
end