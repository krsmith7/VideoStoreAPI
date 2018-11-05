class Customer < ApplicationRecord
  validates :name, presence: true

  has_many :rentals

end
