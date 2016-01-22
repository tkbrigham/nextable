class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.integer :total_friends
      t.datetime :birthday

      t.timestamps
    end
  end
end
