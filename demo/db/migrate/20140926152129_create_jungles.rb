class CreateJungles < ActiveRecord::Migration
  def up
    create_table :jungles do |t|
      t.string :name
      t.string :location
    end
  end
  
  def down
    drop_table :jungles
  end
end
