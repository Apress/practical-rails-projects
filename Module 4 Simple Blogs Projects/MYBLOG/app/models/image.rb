class Image < ActiveRecord::Base
  validates_presence_of :name, :extension
  validates_uniqueness_of :name

  DIRECTORY = 'public/uploaded_images'
    
  def path
    File.join(DIRECTORY, "#{self.id}.#{extension}")
  end

  def url
    path.sub(/^public/,'')
  end
  
  def save_file(data)
    File.open(path, 'wb') { |f| f.write(data) }
  end
end
