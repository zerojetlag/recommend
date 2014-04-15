class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :student_number
      t.string :name
      t.integer :count

      t.timestamps
    end
    add_index :users, [:student_number], unique: true, name:'student_number'
  end
end
