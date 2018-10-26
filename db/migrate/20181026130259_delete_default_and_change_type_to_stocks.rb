class DeleteDefaultAndChangeTypeToStocks < ActiveRecord::Migration[5.2]
  def change
    change_column_default :stocks, :holder_id, nil
    change_column :stocks, :holder_id, :integer
    change_column :stocks, :registerer_id, :integer
  end
end
