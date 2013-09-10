class RemoveAdminFromUsers < ActiveRecord::Migration
  def up

    # Convert from admin flag to roles
    say_with_time "Populating roles..." do
      User.reset_column_information
      Site.reset_column_information

      # Make all admin users an admin of every site in the system,
      # since the original admin flag doesn't differentiate
      User.where(:admin => true).each do |user|
        Site.all.each do |site|
          user.add_role :admin, site
        end
      end
    end

    remove_column :users, :admin
  end

  def down
    add_column :users, :admin, :boolean


    # Convert from roles to admin flag
    say_with_time "Updating admin flags..." do
      User.reset_column_information
      Site.reset_column_information

      # Add admin flag to any user who has an admin role
      #
      # This means that they become admins of every site, 
      # since the original system doesn't differentiate
      Role.where(:name => 'admin').each do |role|
        role.users.each do |user|
          user.update_attribute(:admin, true)
        end
      end
    end
  end
end
