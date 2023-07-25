class Game < ApplicationRecord
  belongs_to :home_team, class_name: 'Team', foreign_key: 'home_team_id'
  belongs_to :away_team, class_name: 'Team', foreign_key: 'away_team_id'
  belongs_to :winning_team, class_name: 'Team', foreign_key: 'winning_team_id', optional: true
  belongs_to :predicted_winning_team, class_name: 'Team', foreign_key: 'predicted_winning_team_id', optional: true

  has_many :game_stats

  scope :ordered_by_time, -> { order(Arel.sql("TO_TIMESTAMP(time, 'hh:mi AM')")) }
end
