class Rental < ApplicationRecord
  before_validation :set_dates
  validates :checkout, presence: true
  validates :due_date, presence: true

  belongs_to :customer
  belongs_to :movie

  private

  def set_dates
    if self.checkout == nil && self.due_date == nil
      self.checkout = Date.today
      self.due_date = Date.today + 7
    end
  end

end
