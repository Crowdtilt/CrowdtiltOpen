require 'spec_helper'


describe Api::V0::PaymentsController do
  describe '#index' do
    let(:site) { create(:site) }
    let!(:api_key) { site.api_key }

    let(:campaign) { create(:campaign) }
    let!(:first_payment) { create(:payment, campaign: campaign) }
    let!(:second_payment) { create(:payment, campaign: campaign) }

    subject { get :index, campaign_id: campaign.id, api_key: api_key }

    it 'lists ALL of the payments for the campaign' do
      serializer_double = double("serializer", serializable_hash: {payment: true})
      PaymentSerializer.should_receive(:new).with(first_payment, anything).and_return(serializer_double)
      PaymentSerializer.should_receive(:new).with(second_payment, anything).and_return(serializer_double)

      subject

      json = JSON.parse(response.body)
      json.should == [{'payment' => true}, {'payment' => true}]
    end
  end
end
