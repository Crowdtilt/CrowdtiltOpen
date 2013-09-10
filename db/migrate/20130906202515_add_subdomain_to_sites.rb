class AddSubdomainToSites < ActiveRecord::Migration
  def change
    # Subdomain should be non null but we add the constraint 
    # later to deal with existing data in the table.
    add_column :sites, :subdomain, :string

    # Populate existing rows
    say_with_time "Generating subdomains for existing sites..." do
      Site.reset_column_information

      Site.all.find_each do |site|
        subdomain = site.site_name.downcase.strip.gsub(' ', '-').gsub(/[^\w-]/, '') + "-#{SecureRandom.hex(3)}"
        site.update_attribute(:subdomain, subdomain)
      end
    end

    # Add non null constraint to subdomain column
    change_column :sites, :subdomain, :string, :null => false

    add_index :sites, :subdomain, :unique => true
  end
end
