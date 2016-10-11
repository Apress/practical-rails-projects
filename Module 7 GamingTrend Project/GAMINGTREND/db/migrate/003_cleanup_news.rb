class CleanupNews < ActiveRecord::Migration
  def self.up
    remove_index "News", :name => "E3year"
    change_column "News", "Headline", :string, :null => true
    change_column "News", "FrontPage", :string, :null => true
    change_column "News", "Body",      :text,  :null => true
    add_column    "News", "Extended", :text
    remove_column "News", "Summary"
    rename_column "News", "DateAdded", "created_at"
    add_column    "News", "updated_at", :datetime
    change_column "News", "UserID",   :integer,  :null => true
    remove_column "News", "E3year"
    change_column "News", "Active", :boolean
    add_index  "News", "created_at"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration                
  end
end
