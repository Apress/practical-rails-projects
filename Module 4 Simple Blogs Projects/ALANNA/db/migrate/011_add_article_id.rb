class Bare11Resource < ActiveRecord::Base
  include BareMigration
end

class AddArticleId < ActiveRecord::Migration
  def self.up
    Dir.mkdir("#{RAILS_ROOT}/public/files") unless File.directory?("#{RAILS_ROOT}/public/files")
    add_column :resources, :article_id, :integer
    Bare11Resource.reset_column_information
    # TODO: resources probably don't get migrated properly.
    # Resource.find(:all) { |r| r.update }
  end

  def self.down
    remove_column :resources, :article_id
  end
end
