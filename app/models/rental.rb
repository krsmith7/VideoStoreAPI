class Rental < ApplicationRecord
  validates :checkout, presence: true
  validates :due_date, presence: true

  belongs_to :customer
  belongs_to :movie

end
