class CreateResults < ActiveRecord::Migration
  def self.up
    create_table :results do |t|
      t.column :goal_id, :integer
      t.column :date, :date
      t.column :value, :decimal
    end
  end

  def self.down
    drop_table :results
  end
end
