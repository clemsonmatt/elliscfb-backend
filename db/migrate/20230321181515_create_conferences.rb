class CreateConferences < ActiveRecord::Migration[7.0]
  def change
    create_table :conferences do |t|
      t.string :name, null: false
      t.string :name_short, null: false

      t.timestamps
    end
  end
end
