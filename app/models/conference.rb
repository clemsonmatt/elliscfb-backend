class Conference < ApplicationRecord
  has_many :teams, -> { order(name: :asc) }
end
