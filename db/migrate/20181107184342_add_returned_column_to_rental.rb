class AddReturnedColumnToRental < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :returned, :boolean, default: false
  end
end
