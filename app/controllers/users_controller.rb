class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def ManageUsers
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @filterString = '0'
    if(params[:selectStatus] != nil)
      @filterString = params[:selectStatus]
    end
    
    @queryDate = ""
    @DateFrom = ""
    @DateTo = ""
    if(params[:textDateFrom] != nil)
      @DateFrom = params[:textDateFrom]
    end
    
    if(params[:textDateTo] != nil)
      @DateTo = params[:textDateTo]
    end
    if(@DateFrom != "" && @DateTo != "")
      @queryDate = "userPay.ResponseDateTime BETWEEN '" + @DateFrom + "' AND '" + @DateTo + "'"
    elsif(@DateFrom != "" && @DateTo == "")
      @queryDate = "userPay.ResponseDateTime BETWEEN '" + @DateFrom + "' AND '" + @DateFrom + "'"
    elsif(@DateFrom == "" && @DateTo != "")
      @queryDate = "userPay.ResponseDateTime BETWEEN '" + @DateTo + "' AND '" + @DateTo + "'"
    else
      @queryDate = ""
    end
    
    @queryStatus = ""
    if(@filterString == '0')
      @queryStatus = ""
    elsif(@filterString == '1')
      @queryStatus = "subUser.IsActivated = '1'"
    elsif(@filterString == '2')
      @queryStatus = "subUser.IsActivated = '0'"
    elsif(@filterString == '3')
      @queryStatus = "subUser.IsSubscribed = '1'"
    elsif(@filterString == '4')
      @queryStatus = "subUser.IsSubscribed = '0'"
    end
    
    if(@queryStatus != "" && @queryDate != "")
      @subUser = SubscribedUser.find_by_sql("SELECT distinct subUser.*, userPay.ResponseDateTime as SubscriptionDate FROM SubscribedUsers subUser
                  LEFT JOIN UserPaymentDetails userPay ON subUser.id = userPay.UserID where " + @queryDate + " and " + @queryStatus)
    elsif(@queryStatus == "" && @queryDate != "")
      @subUser = SubscribedUser.find_by_sql("SELECT distinct subUser.*, userPay.ResponseDateTime as SubscriptionDate FROM SubscribedUsers subUser
                  LEFT JOIN UserPaymentDetails userPay ON subUser.id = userPay.UserID where " + @queryDate)
    elsif(@queryStatus != "" && @queryDate == "")
      @subUser = SubscribedUser.find_by_sql("SELECT distinct subUser.*, userPay.ResponseDateTime as SubscriptionDate FROM SubscribedUsers subUser
                  LEFT JOIN UserPaymentDetails userPay ON subUser.id = userPay.UserID where " + @queryStatus)
    else
      @subUser = SubscribedUser.find_by_sql("SELECT distinct subUser.*, userPay.ResponseDateTime as SubscriptionDate FROM SubscribedUsers subUser
                  LEFT JOIN UserPaymentDetails userPay ON subUser.id = userPay.UserID")
    end 
          
  end
  
  def AddUser
    
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @usercompanyName = params[:textCompany]
    @userfirstName = params[:textFirstName]
    @userlastName = params[:textLastName]
    @userincorporationType = params[:textIncorporationType]
    @userbussStreetAddress = params[:textBussStreetAddress]
    
    @userbusscitystateVal = params[:textBussCity]    
    @userbussCity = ""
    @userbussState = ""
    if(!@userbusscitystateVal.blank?)
      @userbusscitystateVal = @userbusscitystateVal.split(',')    
      @userbussCity = @userbusscitystateVal.at(0).strip()      
      @userbussState = @userbusscitystateVal.at(1).strip()      
    end
    @userbussZipCode = params[:textBussZipCode]
    
    @usermailStreetAddress = params[:textMailStreetAddress]    
    @usermailcitystateVal = params[:textMailCity]
    @usermailCity = ""
    @usermailState = ""
    if(!@usermailcitystateVal.blank?)    
      @usermailcitystateVal = @usermailcitystateVal.split(',')
      @usermailCity = @usermailcitystateVal.at(0).strip()
      @usermailState = @usermailcitystateVal.at(1).strip()      
    end
    @usermailZipCode = params[:textMailZipCode]
    @userphoneNumber = params[:textPhoneNumber]
    @useremail = params[:textEmail]
    @userlicense = params[:textLicense]
    @userName = params[:textUserName]
    password = params[:textPassword]
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
    status = true
    
    #Generating encrypted password
    if(!password.blank?)
      #salt = BCrypt::Engine.generate_salt
      #password = BCrypt::Engine.hash_secret(password, salt)
      salt = currentTime.strftime("%Y%m%d").to_str
      encryptedpassword = AuthenticationController.new()
      password = encryptedpassword.password_encryption(password, salt)
    end
    
    
    if(@usercompanyName != nil and @userfirstName != nil and @userlastName != nil and @userincorporationType != nil and 
      @userbussStreetAddress != nil and @userbussCity != nil and @userbussZipCode != nil and
      @usermailStreetAddress != nil and @usermailCity != nil and @usermailZipCode != nil and
      @userphoneNumber != nil and @useremail != nil and @userlicense != nil and @userName != nil and password != nil and salt != nil)
          
        isUsed='0'         
        userExistence = SubscribedUser.find_by(UserName: @userName)
        emailExistence = SubscribedUser.find_by(EmailID: @useremail)
        licenseExistence = SubscribedUser.find_by(LicenseNumber: @userlicense)
        companyExistence = SubscribedUser.find_by(CompanyName: @usercompanyName)

        if(!userExistence.blank?)
          status = false
          @messageString="Error Message : Username already exists."  
        end
                  
        if(!emailExistence.blank?)
          status = false
          @messageString="Error Message : Email ID already exists."  
        end
                         
        if(!licenseExistence.blank? && keyCode == nil)
          status = false
          @messageString="Error Message : License Number already exists."  
        end    
                         
        if(!companyExistence.blank? && keyCode == nil)
          status = false
          @messageString="Error Message : Company name already exists."
        end      
        
        if(status == true)
          @messageString = ''
                          
          #Save User Information
          @subscribedUser = SubscribedUser.new(UserName: @userName, Password: password, Salt: salt, FirstName: @userfirstName,
          LastName: @userlastName, EmailID: @useremail, CompanyName: @usercompanyName, IncorporationType: @userincorporationType,
          ContactNumber: @userphoneNumber, LicenseNumber: @userlicense, AuthCodeUsed: isUsed, IsActivated: 0, IsSubscribed: 0, 
          DateCreated: time, DateUpdated: time)        
          @subscribedUser.save 
        
          #Get UserID for User to save user address details.
          user = SubscribedUser.find_by(UserName: @userName)
        
          #Save Address Details
          @userBussAddressDetail = UserAddressDetail.new(UserID: user.ID, AddressType: 'Business', Address: @userbussStreetAddress, City: @userbussCity, State: @userbussState, ZIPCode: @userbussZipCode, DateCreated: time, DateUpdated: time)
          @userBussAddressDetail.save
        
          @userMailAddressDetail = UserAddressDetail.new(UserID: user.ID, AddressType: 'Mailing' , Address: @usermailStreetAddress, City: @usermailCity, State: @usermailState, ZIPCode: @usermailZipCode, DateCreated: time, DateUpdated: time)
          @userMailAddressDetail.save
        
          redirect_to users_ManageUsers_url, :notice => "User added successfuly!"      
      end
      
    end 
  end    
       
  def EditUser
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @userID = params[:hidUserID]
    if(!@userID.blank?)
      @subUser = SubscribedUser.find_by(ID: @userID)
      @subAddress1 = UserAddressDetail.find_by(UserID: @userID, AddressType: 'Business')
      @subAddress2 = UserAddressDetail.find_by(UserID: @userID, AddressType: 'Mailing')
      @subPrice = UserPaymentDetail.find_by(UserID: @userID)
      @subAuthKey = Key.find_by(UserID: @userID)
      if(!@subUser.blank?)
        @usercompanyName = @subUser.CompanyName
        @userfirstName = @subUser.FirstName
        @userlastName = @subUser.LastName
        @userincorporationType = @subUser.IncorporationType
        @userphoneNumber = @subUser.ContactNumber
        @useremail = @subUser.EmailID
        @userlicense = @subUser.LicenseNumber
        @userName = @subUser.UserName
        
        @userbussStreetAddress = @subAddress1.Address    
        @userbusscitystateVal = @subAddress1.City + ', ' + @subAddress1.State     
        @userbussZipCode = @subAddress1.ZIPCode 
        
        @usermailStreetAddress = @subAddress2.Address  
        @usermailcitystateVal = @subAddress2.City + ', ' + @subAddress2.State 
        @usermailZipCode = @subAddress2.ZIPCode
        
        if(@userbussStreetAddress == @usermailStreetAddress && @userbusscitystateVal == @userbusscitystateVal && @userbussZipCode == @usermailZipCode)
          @addressCheck = true
        else
          @addressCheck = false
        end
      end
    end
  end
  
  def UpdateUser
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
    
      @userID = params[:hidUserID]
      @usercompanyName = params[:textCompany]
      @userfirstName = params[:textFirstName]
      @userlastName = params[:textLastName]
      @userincorporationType = params[:textIncorporationType]
      @userbussStreetAddress = params[:textBussStreetAddress]
    
      @userbusscitystateVal = params[:textBussCity]    
      @userbussCity = ""
      @userbussState = ""
      if(!@userbusscitystateVal.blank?)
        @userbusscitystateVal = @userbusscitystateVal.split(',')    
        @userbussCity = @userbusscitystateVal.at(0).strip()      
        @userbussState = @userbusscitystateVal.at(1).strip()      
      end
      @userbussZipCode = params[:textBussZipCode]
    
      @usermailStreetAddress = params[:textMailStreetAddress]    
      @usermailcitystateVal = params[:textMailCity]
      @usermailCity = ""
      @usermailState = ""
      if(!@usermailcitystateVal.blank?)    
        @usermailcitystateVal = @usermailcitystateVal.split(',')
        @usermailCity = @usermailcitystateVal.at(0).strip()
        @usermailState = @usermailcitystateVal.at(1).strip()      
      end
      @usermailZipCode = params[:textMailZipCode]
      @userphoneNumber = params[:textPhoneNumber]
      @useremail = params[:textEmail]
      @userlicense = params[:textLicense]
      @isSubscribed = params[:chkSubscribed]
      @isActivated = params[:chkActivated]
      @isApproved = params[:chkApproved]
      @isEnabled = params[:chkEnabled]
      
      @subUser = SubscribedUser.find_by(ID: @userID)
      @subAddress1 = UserAddressDetail.find_by(UserID: @userID, AddressType: 'Business')
      @subAddress2 = UserAddressDetail.find_by(UserID: @userID, AddressType: 'Mailing')
      
      @subUser.FirstName = @userfirstName
      @subUser.LastName = @userlastName
      @subUser.EmailID = @useremail
      @subUser.CompanyName = @usercompanyName
      @subUser.IncorporationType = @userincorporationType
      @subUser.ContactNumber = @userphoneNumber 
      @subUser.LicenseNumber = @userlicense
      
      if(@isActivated)
        @subUser.IsActivated = 1 
      else
        @subUser.IsActivated = 0
      end
      
      @subUser.DateUpdated = time        
      @subUser.save 
        
      @subAddress1.Address = @userbussStreetAddress
      @subAddress1.City = @userbussCity
      @subAddress1.State = @userbussState
      @subAddress1.ZIPCode = @userbussZipCode
      @subAddress1.DateUpdated = time
      @subAddress1.save
        
      @subAddress2.Address = @usermailStreetAddress
      @subAddress2.City = @usermailCity
      @subAddress2.State = @usermailState
      @subAddress2.ZIPCode = @usermailZipCode
      @subAddress2.DateUpdated = time
      @subAddress2.save
      
      redirect_to users_ManageUsers_url, :notice => "User updated successfuly!"
  end
  
  def UserActivation
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
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
    @subUser = SubscribedUser.find_by(ID: @userID)
    @subUser.IsActivated = @status.to_i
    @subUser.DateUpdated = time
    @subUser.save
  end
end
