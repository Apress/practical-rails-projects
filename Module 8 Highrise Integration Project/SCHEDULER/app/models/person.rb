class Person < Highrise
  def notes
    Note.find(:all, :from => "/people/#{id}/notes.xml")
  end

  def upcoming_tasks
    Task.find(:all, :from => "/people/#{id}/tasks.xml")
  end
  
  def name
     "#{first_name} #{last_name}".strip
  end

end
