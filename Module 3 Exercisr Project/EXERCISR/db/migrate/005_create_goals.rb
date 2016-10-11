class CreateGoals < ActiveRecord::Migration
  def self.up
    create_table :goals do |t|
      t.column :name, :string
      t.column :value, :decimal
      t.column :last, :decimal
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :goals
  end
end
