class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.string :password_digest
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email, null: false
      t.json :roles
      t.boolean :email_subscription, default: 0
      t.string :phone
      t.boolean :text_subscription, default: 0
      t.string :phone_carrier

      t.timestamps
    end
  end
end
