class CreateBookInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :book_infos do |t|
      t.string :isbn
      t.string :title
      t.string :author

      t.timestamps
    end
  end
end
