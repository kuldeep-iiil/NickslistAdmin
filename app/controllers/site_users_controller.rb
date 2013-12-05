class SiteUsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  
  
  def ManageUsers
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @siteUser = SiteUser.all
  end

  def AddUser
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    if(params[:textFirstName] != nil && params[:textLastName] != nil && params[:textEmail] != nil && params[:textUserName] != nil && params[:textPassword] != nil)
      @userfirstName = params[:textFirstName]
      @userlastName = params[:textLastName]    
      @useremail = params[:textEmail]
      @userName = params[:textUserName]
      password = params[:textPassword]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      status = true
      userExistence = SiteUser.find_by(UserName: @userName)
      emailExistence = SiteUser.find_by(EmailID: @useremail)
  
      if(!userExistence.blank?)
        status = false
        @messageString="Error Message : Username already exists."  
      end
                  
      if(!emailExistence.blank?)
        status = false
        @messageString="Error Message : Email ID already exists."  
      end    
        
      if(status == true)
        @messageString = ''
           
        #Generating encrypted password
        if(!password.blank?)
          #salt = BCrypt::Engine.generate_salt
          #password = BCrypt::Engine.hash_secret(password, salt)
          salt = currentTime.strftime("%Y%m%d").to_str
          encryptedpassword = AuthenticationController.new()
          password = encryptedpassword.password_encryption(password, salt)
        end
    
        #Save User Information
        @siteUser = SiteUser.new(UserName: @userName, Password: password, Salt: salt, 
                  FirstName: @userfirstName, LastName: @userlastName, EmailID: @useremail, 
                  IsActivated: 0, DateCreated: time, DateUpdated: time)        
        @siteUser.save
      
        redirect_to site_users_ManageUsers_url, :notice => "User added successfuly!"
      end    
    end
  end

  def EditUser
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
   
    @userID = params[:hidUserID]
    @messageString = params[:hidMessage]
    if(!@userID.blank?)
      @siteUser = SiteUser.find_by(ID: @userID)
      if(!@siteUser.blank?)
        @userFirstName = @siteUser.FirstName
        @userLastName = @siteUser.LastName
        @userEmail = @siteUser.EmailID
        @userUserName = @siteUser.UserName
      end
    end
  end

  def UpdateUser
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
     
     if(params[:textFirstName] != nil && params[:textLastName] != nil && params[:textEmail] != nil && params[:textUserName] != nil)
      @userID = params[:hidUserID]
      @userFirstName = params[:textFirstName]
      @userLastName = params[:textLastName]
      @userEmail = params[:textEmail]
      @userUserName = params[:textUserName]
      
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      
      @siteUser = SiteUser.find_by(ID: @userID)
      @siteUser.FirstName = @userFirstName
      @siteUser.LastName = @userLastName
      @siteUser.EmailID = @userEmail
      @siteUser.UserName = @userUserName
      @siteUser.DateUpdated = time      
      @siteUser.save
      
      redirect_to site_users_ManageUsers_url, :notice => "User updated successfuly!"
    end
  end

  def ChangePassword
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      @userID = params[:hidUserID]
      password = params[:textPassword]
      if(!password.blank?)
          #salt = BCrypt::Engine.generate_salt
          #password = BCrypt::Engine.hash_secret(password, salt)
          salt = currentTime.strftime("%Y%m%d").to_str
          encryptedpassword = AuthenticationController.new()
          password = encryptedpassword.password_encryption(password, salt)
        end
      
      
      @siteUser = SiteUser.find_by(ID: @userID)
      @siteUser.Password = password
      @siteUser.DateUpdated = time      
      @siteUser.save
      
  end

  def EditRoles
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @userID = params[:hidUserID]
    @siteModule = SiteModule.all
    @siteModuleUser = SiteModuleUserJoin.where(UserID: @userID)
    
  end
  
  def AddUpdateRoles
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
    @userID = params[:hidUserID]
    @moduleIDs =''
    if(!params[:chkModule1].blank?)
      @moduleIDs = params[:chkModule1]  
      @count = SiteModuleUserJoin.where(ModuleID: params[:chkModule1], UserID: @userID).count
      if(@count.to_i == 0)
        @siteModuleUser = SiteModuleUserJoin.new(ModuleID: params[:chkModule1].to_i, UserID: @userID.to_i, DateCreated: time, DateUpdated: time)
        @siteModuleUser.save
      end
    end
    
    if(!params[:chkModule2].blank?)
      if(!@moduleIDs.blank?)
        @moduleIDs = @moduleIDs + ',' + params[:chkModule2]   
      else
        @moduleIDs = params[:chkModule2]
      end
      @count = SiteModuleUserJoin.where(ModuleID: params[:chkModule2], UserID: @userID).count
      if(@count.to_i == 0)
        @siteModuleUser = SiteModuleUserJoin.new(ModuleID: params[:chkModule2].to_i, UserID: @userID.to_i, DateCreated: time, DateUpdated: time)
        @siteModuleUser.save
      end
    end
    
    if(!params[:chkModule3].blank?)
      if(!@moduleIDs.blank?)
        @moduleIDs = @moduleIDs + ',' + params[:chkModule3]   
      else
        @moduleIDs = params[:chkModule3]
      end
      @count = SiteModuleUserJoin.where(ModuleID: params[:chkModule3], UserID: @userID).count
      if(@count.to_i == 0)
        @siteModuleUser = SiteModuleUserJoin.new(ModuleID: params[:chkModule3].to_i, UserID: @userID.to_i, DateCreated: time, DateUpdated: time)
        @siteModuleUser.save
      end
    end
    
    if(!params[:chkModule4].blank?)
      if(!@moduleIDs.blank?)
        @moduleIDs = @moduleIDs + ',' + params[:chkModule4]   
      else
        @moduleIDs = params[:chkModule4]
      end
      @count = SiteModuleUserJoin.where(ModuleID: params[:chkModule4], UserID: @userID).count
      if(@count.to_i == 0)
        @siteModuleUser = SiteModuleUserJoin.new(ModuleID: params[:chkModule4].to_i, UserID: @userID.to_i, DateCreated: time, DateUpdated: time)
        @siteModuleUser.save
      end
    end
    
    if(!@moduleIDs.blank?)
      @siteModuleUser = SiteModuleUserJoin.find_by_sql("DELETE FROM SiteModuleUserJoin where UserID =" + @userID + " and ModuleID NOT IN (" + @moduleIDs + ")" )
    else
      @siteModuleUser = SiteModuleUserJoin.find_by_sql("DELETE FROM SiteModuleUserJoin where UserID =" + @userID)
    end
    redirect_to site_users_ManageUsers_url, :notice => "User's permission updated successfuly!"
  end
  
  def UserActivation
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
    @userID = params[:hidUserID]
    @status = params[:hidActivate]
    @siteUser = SiteUser.find_by(ID: @userID)
    @siteUser.IsActivated = @status.to_i
    @siteUser.DateUpdated = time
    @siteUser.save 
  end
end