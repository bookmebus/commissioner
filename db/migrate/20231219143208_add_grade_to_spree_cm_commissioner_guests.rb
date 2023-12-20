class AddGradeToSpreeCmCommissionerGuests < ActiveRecord::Migration[7.0]
  def change
    add_column :cm_guests, :grade, :integer, if_not_exists: true
  end
end
