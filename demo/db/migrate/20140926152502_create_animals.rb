class CreateAnimals < ActiveRecord::Migration
  def up
    create_table :animals do |t|
      t.string :name
      t.integer :jungle_id
    end
  end
  def down
    drop_table :animals
  end
end
