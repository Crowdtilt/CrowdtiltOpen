class AddErrorsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :ct_tokenize_request_id, :string
    add_column :payments, :ct_tokenize_request_error_id, :string
    add_column :payments, :ct_charge_request_id, :string
    add_column :payments, :ct_charge_request_error_id, :string
  end
end
