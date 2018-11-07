class Rental < ApplicationRecord
  validates :checkout, presence: true
  validates :due_date, presence: true
  before_create :set_dates

  belongs_to :customer
  belongs_to :movie

  private

  def set_dates
    self.checkout = Date.today
    self.due_date = Date.today + 7
  end

end
