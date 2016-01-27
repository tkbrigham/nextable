class CreatePostgresUsers < ActiveRecord::Migration
  def change
    create_table :pg_users do |t|
      t.string :name
      t.integer :total_friends
      t.date :date_of_birth
      t.time :time_of_birth

      t.timestamps
    end
  end

  def connection
    ActiveRecord::Base.establish_connection("nextable-dev-pg").connection
  end
end
