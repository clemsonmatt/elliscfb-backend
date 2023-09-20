class CreateRankings < ActiveRecord::Migration[7.0]
  def change
    create_table :rankings do |t|
      t.references :week, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.string :poll
      t.integer :rank

      t.timestamps
    end
  end
end
