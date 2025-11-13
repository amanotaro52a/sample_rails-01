class AddImageToWorks < ActiveRecord::Migration[7.2]
  def change
    add_column :works, :image_data, :text
  end
end
