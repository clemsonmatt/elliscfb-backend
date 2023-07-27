class AddCfbdGameIdToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :cfbd_game_id, :integer
  end
end
