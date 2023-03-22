class Week < ApplicationRecord
  belongs_to :season
  # has_many :games, through: :season, ->(start_date, end_date) { where('date >= ? && date <= ?', start_date, end_date) }
end
