class CreateWeeks < ActiveRecord::Migration[7.0]
  def change
    create_table :weeks do |t|
      t.references :season, null: false, foreign_key: true
      t.integer :number, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
