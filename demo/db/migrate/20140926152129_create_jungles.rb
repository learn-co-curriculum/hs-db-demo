class CreateJungles < ActiveRecord::Migration
  def up
    create_table :jungles do |t|
      t.string  :size
      t.string  :name
      t.string  :location
      t.integer :rainfall
    end
  end
  
  def down
    drop_table :jungles
  end
end
