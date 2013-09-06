# == Schema Information
# Schema version: 20130906202515
#
# Table name: faqs
#
#  id          :integer          not null, primary key
#  question    :text
#  answer      :text
#  sort_order  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  campaign_id :integer
#

class Faq < ActiveRecord::Base
  belongs_to :campaign
  attr_accessible :question, :answer, :sort_order, :campaign_id
end
