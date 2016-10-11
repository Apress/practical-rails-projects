class CleanupGames < ActiveRecord::Migration
  def self.up
    remove_column "Games", "AvgReview"
    remove_column "Games", "LastEditedBy"
    remove_column "Games", "AssignedTo"
    remove_column "Games", "Verified"
    remove_column "Games", "E304"
    remove_index  "Games", :name => "E304"
    remove_index  "Games", :name => "descrip"
    rename_column "Games", "DateAdded", "created_at"
    rename_column "Games", "DateEdited", "updated_at"
    change_column "Games", "Title",        :string,   :null => true
    change_column "Games", "Console",      :string,   :null => true
    change_column "Games", "ESRB",         :string
    change_column "Games", "GenreID",      :integer,  :null => true
    change_column "Games", "AddedBy",      :integer,  :null => true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration            
  end
end
