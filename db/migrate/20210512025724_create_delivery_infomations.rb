class CreateDeliveryInfomations < ActiveRecord::Migration[6.1]
  def change
    create_table :shipments do |t|
      t.string :receipiant_name
      t.string :receipiant_phone
      t.string :receipiant_address
      t.bigint :user_id, null: false

      t.timestamps
    end
    add_foreign_key :shipments, :users
  end
end
