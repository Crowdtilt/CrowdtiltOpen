# == Schema Information
# Schema version: 20130909221117
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
#  site_id     :integer          not null
#
# Indexes
#
#  index_faqs_on_site_id  (site_id)
#

class Faq < ActiveRecord::Base
  belongs_to :campaign
  attr_accessible :question, :answer, :sort_order, :campaign_id

  default_scope { where(site_id: Site.current_id) }
end
