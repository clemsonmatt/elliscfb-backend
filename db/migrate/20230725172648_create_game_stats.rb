class CreateGameStats < ActiveRecord::Migration[7.0]
  def change
    create_table :game_stats do |t|
      t.references :game, null: false, foreign_key: true
      t.references :team, null: false, foreign_key: true
      t.integer :final, null: false
      t.integer :q1
      t.integer :q2
      t.integer :q3
      t.integer :q4
      t.integer :ot
      t.integer :rushing_yards
      t.integer :rushing_attempts
      t.integer :passing_yards
      t.integer :passing_attempts
      t.integer :passing_completions
      t.integer :turnovers
      t.integer :penalty_yards

      t.timestamps
    end
  end
end
