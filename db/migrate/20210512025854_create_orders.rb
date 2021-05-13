class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :note
      t.integer :shipping
      t.integer :total
      t.integer :status, default: 0
      t.bigint :user_id, null: false
      t.bigint :delivery_infomation_id

      t.timestamps
    end
    add_foreign_key :orders, :users
    add_foreign_key :orders, :delivery_infomation
  end
end
