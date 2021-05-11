class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.string :detail
      t.integer :quantity, default: 0
      t.integer :price
      t.bigint :category_id, null: false

      t.timestamps
    end
    add_foreign_key :products, :categories
  end
end
