class Task < Highrise
  def self.upcoming
    find(:all, :from => :upcoming)
  end
    
  def self.completed
    find(:all, :from => :completed)
  end
    
  def person
    @person ||= Person.find(subject_id)
  end
end