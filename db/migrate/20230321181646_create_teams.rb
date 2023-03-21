class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.references :conference, null: false, foreign_key: true
      t.string :name, null: false
      t.string :name_short, null: false
      t.string :name_abbr, null: false
      t.string :slug, null: false
      t.string :mascot
      t.string :city
      t.string :state
      t.string :school
      t.string :stadium_name
      t.string :primary_color
      t.string :secondary_color
      t.string :logo

      t.timestamps
    end
  end
end
