class CreateUsersTable < ActiveRecord::Migration[6.0]
  def change
      create_table :users do |t|
        t.string :username 
        t.string :password_string
        t.integer :age
        t.string :location
        t.string :favorite_resort
      end
    end
end
