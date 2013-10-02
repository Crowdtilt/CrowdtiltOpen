class RewardSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :delivery_date, :number, :campaign_id, :number_of_payments
end