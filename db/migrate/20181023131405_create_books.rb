class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :isbn, limit: 13
      t.string :title
      t.string :author

      t.timestamps
    end
    add_index :books, :isbn, unique: true
  end
end
