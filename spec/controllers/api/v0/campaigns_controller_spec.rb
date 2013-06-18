require 'spec_helper'

describe Api::V0::CampaignsController do
  let(:settings) { create(:settings) }
  let!(:api_key) { settings.api_key }

  let(:campaign) { create(:campaign) }
  let!(:reward) { create(:reward, campaign: campaign) }

  describe '#show' do
    subject { get :show, id: campaign.id, api_key: api_key }

    it 'includes the campaign rewards' do
      serializer_double = double("serializer", serializable_hash: { reward: true })
      RewardSerializer.should_receive(:new).with(reward, anything).and_return(serializer_double)

      subject

      response.should be_ok

      json = JSON.parse(response.body)
      json['rewards'].should == [{'reward' => true}]
    end
  end
end