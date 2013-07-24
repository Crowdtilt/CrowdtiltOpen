describe Reward do

  it "has a valid factory" do
    expect(FactoryGirl.build(:reward)).to be_valid
  end

  it "is invalid without a title" do
    expect(Reward.new(title: nil)).to have(1).errors_on(:title)
  end

  it "is invalid without a description" do
    expect(Reward.new(description: nil)).to have(1).errors_on(:description)
  end

  it "is invalid without a delivery date" do
    expect(Reward.new(delivery_date: nil)).to have(1).errors_on(:delivery_date)
  end

  it "is invalid without a price" do
    expect(Reward.new(price: nil)).to have(1).errors_on(:price)
  end  

end