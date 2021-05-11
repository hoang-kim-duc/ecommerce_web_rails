class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :title, null: false
      t.integer :father_id

      t.timestamps
    end
    add_index :categories, :father_id
    add_index :categories, [:id, :father_id], unique: true
  end
end
