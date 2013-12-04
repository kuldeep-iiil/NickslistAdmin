class UserProfileController < ApplicationController
  skip_before_action :verify_authenticity_token
  def EditProfile
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => user_profile_ViewProfile_url}
    end
    
    @userID = session[:user_id]
    if(!@userID.blank?)
      @siteUsers = SiteUser.find_by(ID: @userID)
          
      @userFirstName = @siteUsers.FirstName
      @userLastName = @siteUsers.LastName    
      @userUserName = @siteUsers.UserName
      @userEmail = @siteUsers.EmailID
      @error = ""
    end
  end

  def ViewProfile
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => user_profile_ViewProfile_url}
    end
    
    @userID = session[:user_id]
    if(!@userID.blank?)
      @siteUser = SiteUser.find_by(ID: @userID)
    
      @userFirstName = @siteUser.FirstName
      @userLastName = @siteUser.LastName    
      @userUserName = @siteUser.UserName
      @userEmail = @siteUser.EmailID
      @error = ""
    end
  end
  
  def UpdateProfile
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => user_profile_ViewProfile_url}
    end
    @userID = session[:user_id]
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
    if(!@userID.blank?)
      @siteUser = SiteUser.find_by(ID: @userID)
      
      @userfirstName = params[:textFirstName]
      @userlastName = params[:textLastName]
      @useremail = params[:textEmail]
      @userUserName = params[:textUserName]    
      @siteUser.FirstName = @userfirstName
      @siteUser.LastName = @userlastName
      @siteUser.EmailID = @useremail
      @siteUser.UserName = @userUserName
      @siteUser.DateUpdated = time
      @siteUser.save
          
    end    
    redirect_to user_profile_ViewProfile_url, :notice => "Profile updated successfuly!"
  end
  
end
