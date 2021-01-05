class CreateResortsTable < ActiveRecord::Migration[6.0]
  def change
      create_table :resorts do |t|
        t.string :name
        t.float :current_temp
        t.string :conditions
      end 
  end
end
