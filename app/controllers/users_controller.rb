class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  def ManageUsers
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @filterString = '0'
      if(params[:selectStatus] != nil)
        @filterString = params[:selectStatus]
      end

      @queryDate = ""
      @dateFrom = ""
      @dateTo = ""

      if(params[:textDateFrom] != nil)
        if(params[:textDateFrom].strip() != '')
          @DateFrom = params[:textDateFrom]
          @dateFrom = Date.strptime(@DateFrom, "%m/%d/%Y").to_s
        end
      end

      if(params[:textDateTo] != nil)
        if(params[:textDateTo].strip() != '')
          @DateTo = params[:textDateTo]
          @dateTo = (Date.strptime(@DateTo, "%m/%d/%Y") + 1.day).to_s
        end
      end

      if(@dateFrom != "" && @dateTo != "")
        @queryDate = "userPay.ResponseDateTime BETWEEN '" + @dateFrom + "' AND '" + @dateTo + "'"
      elsif(@dateFrom != "" && @dateTo == "")
        @queryDate = "userPay.ResponseDateTime >= '" + @dateFrom + "'"
      elsif(@dateFrom == "" && @dateTo != "")
        @queryDate = "userPay.ResponseDateTime <= '" + @dateTo + "'"
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
        @subUser = SubscribedUser.find_by_sql("SELECT distinct subUser.*, userPay.ResponseDateTime as SubscriptionDate
                  FROM subscribed_users subUser
                  LEFT JOIN user_payment_details userPay ON subUser.id = userPay.UserID where " + @queryDate + " and " + @queryStatus)
      elsif(@queryStatus == "" && @queryDate != "")
        @subUser = SubscribedUser.find_by_sql("SELECT distinct subUser.*, userPay.ResponseDateTime as SubscriptionDate
                  FROM subscribed_users subUser
                  LEFT JOIN user_payment_details userPay ON subUser.id = userPay.UserID where " + @queryDate)
      elsif(@queryStatus != "" && @queryDate == "")
        @subUser = SubscribedUser.find_by_sql("SELECT distinct subUser.*, userPay.ResponseDateTime as SubscriptionDate
                  FROM subscribed_users subUser
                  LEFT JOIN user_payment_details userPay ON subUser.id = userPay.UserID where " + @queryStatus)
      else
        @subUser = SubscribedUser.find_by_sql("SELECT distinct subUser.*, userPay.ResponseDateTime as SubscriptionDate
                  FROM subscribed_users subUser
                  LEFT JOIN user_payment_details userPay ON subUser.id = userPay.UserID")
      end
    end
  end

  def AddUser

    @moduleID = SiteModule.find_by(Module: 'Manage Users')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]

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
          @userBussAddressDetail = UserAddressDetail.new(UserID: user.id, AddressType: 'Business', Address: @userbussStreetAddress, City: @userbussCity, State: @userbussState, ZipCode: @userbussZipCode, DateCreated: time, DateUpdated: time)
          @userBussAddressDetail.save

          @userMailAddressDetail = UserAddressDetail.new(UserID: user.id, AddressType: 'Mailing' , Address: @usermailStreetAddress, City: @usermailCity, State: @usermailState, ZipCode: @usermailZipCode, DateCreated: time, DateUpdated: time)
          @userMailAddressDetail.save

          @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '107', TaskID: @subscribedUser.id, DateCreated: time)
          @adminActivity.save
          
          redirect_to users_ManageUsers_url, :notice => "User added successfuly!"
        end

      end
    end
  end

  def EditUser
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]

      @userID = params[:hidUserID]
      @messageString = params[:hidMessage]
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
          @userbussZipCode = @subAddress1.ZipCode

          @usermailStreetAddress = @subAddress2.Address
          @usermailcitystateVal = @subAddress2.City + ', ' + @subAddress2.State
          @usermailZipCode = @subAddress2.ZipCode

          if(@userbussStreetAddress == @usermailStreetAddress && @userbusscitystateVal == @userbusscitystateVal && @userbussZipCode == @usermailZipCode)
            @addressCheck = true
          else
            @addressCheck = false
          end
        end
      end
    end
  end

  def UpdateUser
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
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

      #if(@isActivated)
      #  @subUser.IsActivated = 1
      #else
      #  @subUser.IsActivated = 0
      #end

      @subUser.DateUpdated = time
      @subUser.save

      @subAddress1.Address = @userbussStreetAddress
      @subAddress1.City = @userbussCity
      @subAddress1.State = @userbussState
      @subAddress1.ZipCode = @userbussZipCode
      @subAddress1.DateUpdated = time
      @subAddress1.save

      @subAddress2.Address = @usermailStreetAddress
      @subAddress2.City = @usermailCity
      @subAddress2.State = @usermailState
      @subAddress2.ZipCode = @usermailZipCode
      @subAddress2.DateUpdated = time
      @subAddress2.save
      
      @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '108', TaskID: @subUser.id, DateCreated: time)
      @adminActivity.save
      
      @subscribedUser = SubscribedUserHistory.new(ReportID: @adminActivity.id, UserID: @subUser.id, UserName: @subUser.UserName, Password: @subUser.Password, Salt: @subUser.Salt, FirstName: @subUser.FirstName,
          LastName: @subUser.LastName, EmailID: @subUser.EmailID, CompanyName: @subUser.CompanyName, IncorporationType: @subUser.IncorporationType,
          ContactNumber: @subUser.ContactNumber, LicenseNumber: @subUser.LicenseNumber, AuthCodeUsed: @subUser.AuthCodeUsed, IsActivated: @subUser.IsActivated, IsSubscribed: @subUser.IsSubscribed, 
          DateCreated: time, DateUpdated: time)        
          @subscribedUser.save
          
      #Save Address Details
      @userBussAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress1.UserID, AddressType: @subAddress1.AddressType, Address: @subAddress1.Address, City: @subAddress1.City, State: @subAddress1.State, ZipCode: @subAddress1.ZipCode, DateCreated: time, DateUpdated: time)
      @userBussAddressDetail.save
        
      @userMailAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress2.UserID, AddressType: @subAddress2.AddressType , Address: @subAddress2.Address, City: @subAddress2.City, State: @subAddress2.State, ZipCode: @subAddress2.ZipCode, DateCreated: time, DateUpdated: time)
      @userMailAddressDetail.save
      
      redirect_to users_ManageUsers_url, :notice => "User updated successfuly!"
    end
  end

  def ChangePassword
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
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
      password = params[:textPassword]
      if(!password.blank?)
        #salt = BCrypt::Engine.generate_salt
        #password = BCrypt::Engine.hash_secret(password, salt)
        salt = currentTime.strftime("%Y%m%d").to_str
        encryptedpassword = AuthenticationController.new()
      password = encryptedpassword.password_encryption(password, salt)
      end

      @subUser = SubscribedUser.find_by(ID: @userID)
      @subUser.Password = password
      @subUser.Salt = salt
      @subUser.DateUpdated = time
      @subUser.save
      
      @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '109', TaskID: @subUser.id, DateCreated: time)
      @adminActivity.save
    end
  end

  def UserActivation
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
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
      @subUser = SubscribedUser.find_by(ID: @userID)
      @subUser.IsActivated = @status.to_i
      @subUser.DateUpdated = time
      @subUser.save

      if(@status.to_i == 1)
        @userfirstName = @subUser.FirstName
        @userlastName = @subUser.LastName
        @useremail = @subUser.EmailID
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '105', TaskID: @subUser.id, DateCreated: time)
        @adminActivity.save
        
        mail_to_user = UserMailer.UserActivation(@userfirstName, @userlastName, @useremail)
        mail_to_user.deliver
      else
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '106', TaskID: @subUser.id, DateCreated: time)
        @adminActivity.save
      end
    end
  end
end
