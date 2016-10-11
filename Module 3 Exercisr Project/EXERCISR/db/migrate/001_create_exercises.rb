class CreateExercises < ActiveRecord::Migration
  def self.up
    create_table :exercises do |t|
      t.column :name, :string
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :exercises
  end
end
