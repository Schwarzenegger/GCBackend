class AddAccessKeyToAdminUser < ActiveRecord::Migration[5.2]
  def change
    add_column :admin_users, :access_token, :string
  end
end
