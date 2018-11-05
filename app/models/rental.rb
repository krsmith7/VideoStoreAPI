class Rental < ApplicationRecord
  validates :checkout, presence: true
  validates :due_date, presence: true
end
