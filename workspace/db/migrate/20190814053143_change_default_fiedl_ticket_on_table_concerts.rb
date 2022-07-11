class ChangeDefaultFiedlTicketOnTableConcerts < ActiveRecord::Migration[5.1]
  def change
    change_column_default :concerts, :ticket, false
  end
end
