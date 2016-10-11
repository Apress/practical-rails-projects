module ApplicationHelper
  def show_avatar
    if @user.avatar
  	  return @user.avatar.public_filename
  	else
  	  return "no_avatar.gif"
  	end 
  end
  
  def show_small_avatar(user)
    if user.avatar
  	  return user.avatar.public_filename(:comment)
  	else
  	  return "small_no_avatar.gif"
  	end 
  end
  
  def show_thumb(photos)
    if photos.empty?
      return photos.first.public_filename(:thumb)
    else
      return "no_avatar.gif"
    end
  end
  
  def show_admin_menu
    current_user == @user      
  end
  
end
