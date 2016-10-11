class SessionsController < ApplicationController
   def new
   end

   def create
     session[:password] = params[:password]
     if admin?
       redirect_to comics_path
     elsif member?
       redirect_to home_path
     else
       flash[:notice] = "That password was incorrect"
       redirect_to login_path
     end
   end
  
   def destroy
      reset_session
      redirect_to home_path
   end
end
