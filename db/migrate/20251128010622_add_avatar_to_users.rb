class AddAvatarToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :avatar_data, :text
  end
end
