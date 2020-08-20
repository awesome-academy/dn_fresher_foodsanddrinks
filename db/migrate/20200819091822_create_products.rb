class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :name
      t.text :information
      t.float :price
      t.integer :quantity
      t.float :rating_score

      t.timestamps
    end
  end
end
