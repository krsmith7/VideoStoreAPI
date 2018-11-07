class Movie < ApplicationRecord
  validates :title, presence: true, uniqueness: true
  validates :inventory, presence: true, numericality: { only_integer: true }
  before_create :set_available

  has_many :rentals

  private

  def set_available
    self.available_inventory = self.inventory
  end

end
