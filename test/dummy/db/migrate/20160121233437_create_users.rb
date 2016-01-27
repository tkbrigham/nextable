class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :total_friends
      t.date :date_of_birth
      t.time :time_of_birth

      t.timestamps
    end
  end
end
