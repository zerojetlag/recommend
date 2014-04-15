class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.integer :book_number
      t.string :name
      t.string :author
      t.string :publisher
      t.string :born_year
      t.string :isbn
      t.string :shelf
      t.string :first_category
      t.string :second_category

      t.timestamps
    end
  end
end
