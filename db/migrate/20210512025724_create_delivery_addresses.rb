class CreateDeliveryAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :delivery_addresses do |t|
      t.string :name
      t.string :phone
      t.string :address
      t.bigint :user_id, null: false

      t.timestamps
    end
    add_foreign_key :delivery_addresses, :users
  end
end
