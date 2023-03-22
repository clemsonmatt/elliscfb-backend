class Season < ApplicationRecord
  has_many :weeks, -> { order(number: :asc) }
  has_many :games, -> { order(date: :asc) }
end
