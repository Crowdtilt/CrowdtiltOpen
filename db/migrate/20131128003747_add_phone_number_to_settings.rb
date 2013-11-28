class AddPhoneNumberToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :phone_number, :string
  end
end
