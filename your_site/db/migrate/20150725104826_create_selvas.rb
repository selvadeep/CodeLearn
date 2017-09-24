class CreateSelvas < ActiveRecord::Migration
  def change
    create_table :selvas do |t|
      t.string :name
      t.text :address

      t.timestamps null: false
    end
  end
end
