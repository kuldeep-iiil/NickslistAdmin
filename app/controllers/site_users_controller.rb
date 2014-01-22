class SiteUsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def ManageUsers
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @siteUser = SiteUser.all
    end
  end

  def AddUser
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]

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
                  IsActivated: 0, IsSuperAdmin: 0, DateCreated: time, DateUpdated: time)
          @siteUser.save
          
          @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '101', TaskID: @siteUser.id, DateCreated: time)
          @adminActivity.save
          
          @siteUserHistory = SiteUserHistory.new(ReportID: @adminActivity.id, UserID: @siteUser.id, UserName: @userName, Password: password, Salt: salt,
                  FirstName: @userfirstName, LastName: @userlastName, EmailID: @useremail,
                  IsActivated: 0, IsSuperAdmin: 0, DateCreated: time, DateUpdated: time)
          @siteUserHistory.save
          
          redirect_to site_users_ManageUsers_url, :notice => "User added successfuly!"
        end
      end
    end
  end

  def EditUser
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

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
  end

  def UpdateUser
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      
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
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '102', TaskID: @siteUser.id, DateCreated: time)
        @adminActivity.save
        
        @siteUserHistory = SiteUserHistory.new(ReportID: @adminActivity.id, UserID: @siteUser.id, UserName: @siteUser.UserName, Password: @siteUser.Password, Salt: @siteUser.Salt,
                  FirstName: @siteUser.FirstName, LastName: @siteUser.LastName, EmailID: @siteUser.EmailID,
                  IsActivated: @siteUser.IsActivated, IsSuperAdmin: @siteUser.IsSuperAdmin, DateCreated: time, DateUpdated: time)
        @siteUserHistory.save
        
        redirect_to site_users_ManageUsers_url, :notice => "User updated successfuly!"
      end
    end
  end

  def ChangePassword
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      
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
      @siteUser.Salt = salt
      @siteUser.DateUpdated = time
      @siteUser.save
      
      @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '103', TaskID: @siteUser.id, DateCreated: time)
      @adminActivity.save
      
      @siteUserHistory = SiteUserHistory.new(ReportID: @adminActivity.id, UserID: @siteUser.id, UserName: @siteUser.UserName, Password: @siteUser.Password, Salt: @siteUser.Salt,
                  FirstName: @siteUser.FirstName, LastName: @siteUser.LastName, EmailID: @siteUser.EmailID,
                  IsActivated: @siteUser.IsActivated, IsSuperAdmin: @siteUser.IsSuperAdmin, DateCreated: time, DateUpdated: time)
      @siteUserHistory.save
    end
  end

  def EditRoles
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @userID = params[:hidUserID]
      @siteModule = SiteModule.all
      @siteModuleUser = SiteModuleUserJoin.where(UserID: @userID)
    end
  end

  def AddUpdateRoles
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => site_users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]

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

      if(!params[:chkModule5].blank?)
        if(!@moduleIDs.blank?)
          @moduleIDs = @moduleIDs + ',' + params[:chkModule5]
        else
          @moduleIDs = params[:chkModule5]
        end
        @count = SiteModuleUserJoin.where(ModuleID: params[:chkModule5], UserID: @userID).count
        if(@count.to_i == 0)
          @siteModuleUser = SiteModuleUserJoin.new(ModuleID: params[:chkModule5].to_i, UserID: @userID.to_i, DateCreated: time, DateUpdated: time)
          @siteModuleUser.save
        end
      end

      if(!@moduleIDs.blank?)
        @siteModuleUser = SiteModuleUserJoin.find_by_sql("DELETE FROM site_module_user_joins where UserID =" + @userID + " and ModuleID NOT IN (" + @moduleIDs + ")" )
      else
        @siteModuleUser = SiteModuleUserJoin.find_by_sql("DELETE FROM site_module_user_joins where UserID =" + @userID)
      end
      
      
      
      @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '104', TaskID: '0', DateCreated: time)
      @adminActivity.save
      
      @siteUser = SiteUser.find_by(ID: @userID)
      @siteUserHistory = SiteUserHistory.new(ReportID: @adminActivity.id, UserID: @siteUser.id, UserName: @siteUser.UserName, Password: @siteUser.Password, Salt: @siteUser.Salt,
                  FirstName: @siteUser.FirstName, LastName: @siteUser.LastName, EmailID: @siteUser.EmailID,
                  IsActivated: @siteUser.IsActivated, IsSuperAdmin: @siteUser.IsSuperAdmin, DateCreated: time, DateUpdated: time)
      @siteUserHistory.save
      
      @siteModuleUserJoin = SiteModuleUserJoin.find_by_sql("select * from site_module_user_joins where UserID = '" + @userID.to_s + "'")
      if(!@siteModuleUserJoin.blank?)
        @siteModuleUserJoin.each do |sUserRole|
          @siteModuleUserHistory = SiteModuleUserJoinHistory.new(ReportID: @adminActivity.id, ModuleID: sUserRole.ModuleID, UserID: sUserRole.UserID, DateCreated: time, DateUpdated: time)
          @siteModuleUserHistory.save
        end
      end
      redirect_to site_users_ManageUsers_url, :notice => "User's permission updated successfuly!"
    end
  end

  def UserActivation
    @moduleID = SiteModule.find_by(Module: 'Manage Admin')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      @userID = params[:hidUserID]
      @status = params[:hidActivate]
      @siteUser = SiteUser.find_by(ID: @userID)
      @siteUser.IsActivated = @status.to_i
      @siteUser.DateUpdated = time
      @siteUser.save
      
      if(@status.to_i == 1)
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '132', TaskID: @siteUser.id, DateCreated: time)
        @adminActivity.save
        
        @siteUserHistory = SiteUserHistory.new(ReportID: @adminActivity.id, UserID: @siteUser.id, UserName: @siteUser.UserName, Password: @siteUser.Password, Salt: @siteUser.Salt,
                  FirstName: @siteUser.FirstName, LastName: @siteUser.LastName, EmailID: @siteUser.EmailID,
                  IsActivated: @siteUser.IsActivated, IsSuperAdmin: @siteUser.IsSuperAdmin, DateCreated: time, DateUpdated: time)
        @siteUserHistory.save
      else
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '133', TaskID: @siteUser.id, DateCreated: time)
        @adminActivity.save
        
        @siteUserHistory = SiteUserHistory.new(ReportID: @adminActivity.id, UserID: @siteUser.id, UserName: @siteUser.UserName, Password: @siteUser.Password, Salt: @siteUser.Salt,
                  FirstName: @siteUser.FirstName, LastName: @siteUser.LastName, EmailID: @siteUser.EmailID,
                  IsActivated: @siteUser.IsActivated, IsSuperAdmin: @siteUser.IsSuperAdmin, DateCreated: time, DateUpdated: time)
        @siteUserHistory.save
      end
    end
  end
end