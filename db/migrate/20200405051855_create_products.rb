class CreateProducts < ActiveRecord::Migration[5.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.text :description, null:false
      t.references :size, foreign_key: true
      t.integer :ship_from_location_id, null: false
      t.integer :product_condition_id,	null: false
      t.integer :derivery_fee_payer_id, null: false
      t.integer :derivery_day_id, null: false
      t.references :category, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.timestamps
    end
  end
end
