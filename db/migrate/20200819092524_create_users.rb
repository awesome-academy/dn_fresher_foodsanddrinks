class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      # t.string :email
      t.string :address
      t.string :phone
      t.integer :role, null: false, default: 0

      # t.string :password_digest
      # t.string :remember_digest
      # t.string :activation_digest
      # t.datetime :activated_at

      t.timestamps
    end
  end
end
