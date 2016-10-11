class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.column :workout_id, :integer
      t.column :exercise_id, :integer
      t.column :resistance, :integer
      t.column :repetitions, :integer
    end
  end

  def self.down
    drop_table :activities
  end
end
