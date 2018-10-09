class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :holder
      t.string :registerer
      t.date :duedate
      t.timestamps
    end
  end
end
