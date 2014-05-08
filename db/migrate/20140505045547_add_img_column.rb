class AddImgColumn < ActiveRecord::Migration
  def change
    add_column :urls, :image, :string
  end
end
