class ChangeResortsTable < ActiveRecord::Migration[6.0]
  def change
    change_table :resorts do |t|
      t.remove :current_temp, :conditions
      t.float :lat
      t.float :long
    end
  end
end
