class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :home_team, null: false, foreign_key: { to_table: :teams }
      t.references :away_team, null: false, foreign_key: { to_table: :teams }
      t.references :winning_team, null: true, foreign_key: { to_table: :teams }
      t.date :date, null: false
      t.string :time
      t.string :location
      t.decimal :spread, precision: 3, scale: 1
      t.references :predicted_winning_team, null: true, foreign_key: { to_table: :teams }
      t.boolean :conference_championship, default: false
      t.string :bowl_name
      t.boolean :pickem, default: false
      t.boolean :canceled, default: false
      t.string :network

      t.timestamps
    end
  end
end
