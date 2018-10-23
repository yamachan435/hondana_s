class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.references :book, foreign_key: true
      t.string :holder, default: "office@r-learning.co.jp"
      t.string :registerer
      t.date :duedate

      t.timestamps
    end
  end
end
