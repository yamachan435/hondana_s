class RenameHolderRegisterToBooks < ActiveRecord::Migration[5.2]
  def change
    rename_column :stocks, :holder, :holder_id
    rename_column :stocks, :registerer, :registerer_id
  end
end
