class Week < ApplicationRecord
  belongs_to :season
  # has_many :games, through: :season, ->(start_date, end_date) { where('date >= ? && date <= ?', start_date, end_date) }

  scope :current_week, ->(today = Date.today) { where("start_date <= ? AND end_date >= ?", today, today) }
end
