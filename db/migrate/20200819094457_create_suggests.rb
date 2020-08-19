class CreateSuggests < ActiveRecord::Migration[6.0]
  def change
    create_table :suggests do |t|
      t.string :name
      t.text :information
      t.integer :status, null: false, default: 0
      t.references :user, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
