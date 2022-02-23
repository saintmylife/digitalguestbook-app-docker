class DeleteColumnAmountInGuest < ActiveRecord::Migration[5.1]
  def change
    remove_column :guests, :amount_of_present
  end
end
