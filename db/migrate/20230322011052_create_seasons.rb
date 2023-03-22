class CreateSeasons < ActiveRecord::Migration[7.0]
  def change
    create_table :seasons do |t|
      t.integer :year, null: false
      t.boolean :active, default: 0

      t.timestamps
    end
  end
end
