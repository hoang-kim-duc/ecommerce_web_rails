class CreateOrderDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :order_details do |t|
      t.bigint :product_id
      t.bigint :order_id
      t.integer :quantity
      t.integer :price

      t.timestamps
    end
    add_foreign_key :order_details, :orders
    add_foreign_key :order_details, :products
  end
end
