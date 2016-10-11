class CreateWorkouts < ActiveRecord::Migration
  def self.up
    create_table :workouts do |t|
      t.column :date, :date
      t.column :label, :string
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :workouts
  end
end
