class Movie < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :inventory, presence: true, numericality: { only_integer: true }

  has_many :rentals

end
