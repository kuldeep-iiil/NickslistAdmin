class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  include ActionView::Helpers::NumberHelper
  include Sidekiq::Worker
  def ManageUsers
    @moduleID = SiteModule.find_by(Module: 'Manage Users')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => users_ManageUsers_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      
      @query = "SELECT distinct subUser.*, userPay.DateUpdated as SubscriptionDate
                  FROM subscribed_users subUser
                  LEFT JOIN user_payment_details userPay ON subUser.id = userPay.UserID"
      
      if(params[:hidStatus] != nil)
        params[:selectStatus] = params[:hidStatus]
      end
      if(params[:hidFrom] != nil)
        params[:textDateFrom] = params[:hidFrom]
      end
      if(params[:hidTo] != nil)
        params[:textDateTo] = params[:hidTo]
      end  
      
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
        @subUser = SubscribedUser.find_by_sql(@query + " where " + @queryDate + " and " + @queryStatus)
      elsif(@queryStatus == "" && @queryDate != "")
        @subUser = SubscribedUser.find_by_sql(@query + " where " + @queryDate)
      elsif(@queryStatus != "" && @queryDate == "")
        @subUser = SubscribedUser.find_by_sql(@query + " where " + @queryStatus)
      else
        @subUser = SubscribedUser.find_by_sql(@query)
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
      
      if(params[:hidAuthCode] != nil)
        params[:textCode] = params[:hidAuthCode]
      end
      
      if(params[:textCode] != nil)
        @authCode = params[:textCode]
        key = Key.find_by(Key: @authCode)
        if(!key.blank?)  
          userDetails = SubscribedUser.find_by(ID: key.UserID)
          userBussAddressDetails = UserAddressDetail.find_by(UserID: key.UserID, AddressType: 'Business')
          userMailAddressDetails = UserAddressDetail.find_by(UserID: key.UserID, AddressType: 'Mailing')
        
          params[:textCompany] = userDetails.CompanyName
          params[:textIncorporationType] = userDetails.IncorporationType
          params[:textBussStreetAddress] = userBussAddressDetails.Address
          params[:textBussCity] = userBussAddressDetails.City
          params[:textBussState] = userBussAddressDetails.State
          params[:textBussZipCode] = userBussAddressDetails.ZipCode
          params[:textMailStreetAddress] = userMailAddressDetails.Address
          params[:textMailCity] = userMailAddressDetails.City
          params[:textMailState] = userMailAddressDetails.State
          params[:textMailZipCode] = userMailAddressDetails.ZipCode
          params[:textPhoneNumber] = userDetails.ContactNumber
          #params[:textEmail] = userDetails.EmailID
          params[:textLicense] = userDetails.LicenseNumber
          @error = "0"
        else
          @error = "1"         
          @messageString = "Invalid Authcode!"
        end
      end
      
      
      if(params[:textCompany] != nil && params[:textFirstName] != nil && params[:textLastName] != nil && params[:textIncorporationType] != nil &&
      params[:textBussStreetAddress] != nil && params[:textBussCity] != nil && params[:textBussState] != nil && params[:textBussZipCode] != nil &&
      params[:textMailStreetAddress] != nil && params[:textMailCity] != nil && params[:textMailState] != nil && params[:textMailZipCode] != nil &&
      params[:textPhoneNumber] != nil && params[:textEmail] != nil && params[:textLicense] != nil && params[:textUserName] != nil && params[:textPassword] != nil)
      
      @usercompanyName = params[:textCompany]
      @userfirstName = params[:textFirstName]
      @userlastName = params[:textLastName]
      @userincorporationType = params[:textIncorporationType]
      @userbussStreetAddress = params[:textBussStreetAddress]

      #@userbusscitystateVal = params[:textBussCity]
      @userbussCity = params[:textBussCity]
      @userbussState = params[:textBussState]
      #if(!@userbusscitystateVal.blank?)
      #  @userbusscitystateVal = @userbusscitystateVal.split(',')
      #  @userbussCity = @userbusscitystateVal.at(0).strip()
      #  @userbussState = @userbusscitystateVal.at(1).strip()
      #end
      @userbussZipCode = params[:textBussZipCode]

      @usermailStreetAddress = params[:textMailStreetAddress]
      #@usermailcitystateVal = params[:textMailCity]
      @usermailCity = params[:textMailCity]
      @usermailState = params[:textMailState]
      #if(!@usermailcitystateVal.blank?)
      #  @usermailcitystateVal = @usermailcitystateVal.split(',')
      #  @usermailCity = @usermailcitystateVal.at(0).strip()
      #  @usermailState = @usermailcitystateVal.at(1).strip()
      #end
      @usermailZipCode = params[:textMailZipCode]
      @userphoneNumber = params[:textPhoneNumber]
      @useremail = params[:textEmail]
      @userlicense = params[:textLicense]
      @userName = params[:textUserName]
      password = params[:textPassword]
      keyCode = params[:textCode]
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
      
        if(keyCode.blank?)
          isUsed = '0'
          iscompanyOwner = '1'
          @subPlan = UserSubscriptionPlan.find_by(PlanType: 'New User')
          @itemprice = @subPlan.price
          @price = number_to_currency(@itemprice.to_i, :unit => "$")
        else
          isUsed='1'
          @subPlan = UserSubscriptionPlan.find_by(PlanType: 'Subsequent User')
          @itemprice = @subPlan.price
          @price = number_to_currency(@itemprice.to_i, :unit => "$")
        end
        
        userExistence = SubscribedUser.find_by(UserName: @userName)
        emailExistence = SubscribedUser.find_by(EmailID: @useremail)
        licenseExistence = SubscribedUser.find_by(LicenseNumber: @userlicense)
        companyExistence = SubscribedUser.find_by(CompanyName: @usercompanyName)

        if(!userExistence.blank?)
          status = false
          @messageString="Username already exists."
        end

        if(!emailExistence.blank?)
          status = false
          @messageString="Email ID already exists."
        end

        if(!licenseExistence.blank? && keyCode == nil)
          status = false
          @messageString="License Number already exists."
        end

        if(!companyExistence.blank? && keyCode == nil)
          status = false
          @messageString="Company name already exists."
        end

        if(status == true)
          @messageString = ''

          #Save User Information
          @subUser = SubscribedUser.new(UserName: @userName, Password: password, Salt: salt, FirstName: @userfirstName,
          LastName: @userlastName, EmailID: @useremail, CompanyName: @usercompanyName, IncorporationType: @userincorporationType,
          ContactNumber: @userphoneNumber, LicenseNumber: @userlicense, AuthCodeUsed: isUsed, IsActivated: 0, IsSubscribed: 1, IsNotification: 1,
          DateCreated: time, DateUpdated: time)
          @subUser.save

          #Get UserID for User to save user address details.
          user = SubscribedUser.find_by(UserName: @userName)

          #Save Address Details
          @subAddress1 = UserAddressDetail.new(UserID: user.id, AddressType: 'Business', Address: @userbussStreetAddress, City: @userbussCity, State: @userbussState, ZipCode: @userbussZipCode, DateCreated: time, DateUpdated: time)
          @subAddress1.save

          @subAddress2 = UserAddressDetail.new(UserID: user.id, AddressType: 'Mailing' , Address: @usermailStreetAddress, City: @usermailCity, State: @usermailState, ZipCode: @usermailZipCode, DateCreated: time, DateUpdated: time)
          @subAddress2.save

          @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '107', TaskID: @subUser.id, DateCreated: time)
          @adminActivity.save
          
          @subscribedUser = SubscribedUserHistory.new(ReportID: @adminActivity.id, UserID: @subUser.id, UserName: @subUser.UserName, Password: @subUser.Password, Salt: @subUser.Salt, FirstName: @subUser.FirstName,
          LastName: @subUser.LastName, EmailID: @subUser.EmailID, CompanyName: @subUser.CompanyName, IncorporationType: @subUser.IncorporationType,
          ContactNumber: @subUser.ContactNumber, LicenseNumber: @subUser.LicenseNumber, AuthCodeUsed: @subUser.AuthCodeUsed, IsActivated: @subUser.IsActivated, IsSubscribed: @subUser.IsSubscribed, IsNotification: @subUser.IsNotification, 
          DateCreated: time, DateUpdated: time)        
          @subscribedUser.save
          
          #Save Address Details
          @userBussAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress1.UserID, AddressType: @subAddress1.AddressType, Address: @subAddress1.Address, City: @subAddress1.City, State: @subAddress1.State, ZipCode: @subAddress1.ZipCode, DateCreated: time, DateUpdated: time)
          @userBussAddressDetail.save
        
          @userMailAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress2.UserID, AddressType: @subAddress2.AddressType , Address: @subAddress2.Address, City: @subAddress2.City, State: @subAddress2.State, ZipCode: @subAddress2.ZipCode, DateCreated: time, DateUpdated: time)
          @userMailAddressDetail.save
          
          if(keyCode.blank?)
            isUsed='0'
            @subPlan = UserSubscriptionPlan.find_by(PlanType: 'New User')
            @itemprice = @subPlan.price
            @price = number_to_currency(@itemprice.to_i, :unit => "$")
          else
            isUsed='1'
            @subPlan = UserSubscriptionPlan.find_by(PlanType: 'Subsequent User')
            @itemprice = @subPlan.price
            @price = number_to_currency(@itemprice.to_i, :unit => "$")
          end
          
          @userPaymentDetails = UserPaymentDetail.new(UserID: @subUser.id, TransactionAmount: @price, PayTransactionID: "", ResponseString: "",  DateCreated: time, DateUpdated: time)
          @userPaymentDetails.save
          
          #Create key for the user company to be used by subsicuent user.
          if(keyCode.blank?)
            keyCode = Time.now.to_i
            @keyCode = keyCode
            @key = Key.new(UserID: user.id, Key: keyCode , DateCreated: time)
            @key.save          
          end
          
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
          #@userbusscitystateVal = @subAddress1.City + ', ' + @subAddress1.State
          @userbussCity = @subAddress1.City
          @userbussState = @subAddress1.State
          @userbussZipCode = @subAddress1.ZipCode

          @usermailStreetAddress = @subAddress2.Address
          #@usermailcitystateVal = @subAddress2.City + ', ' + @subAddress2.State
          @usermailCity = @subAddress2.City
          @usermailState = @subAddress2.State
          @usermailZipCode = @subAddress2.ZipCode

          if(@userbussStreetAddress == @usermailStreetAddress && @userbussCity == @usermailCity && @userbussState == @usermailState && @userbussZipCode == @usermailZipCode)
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

      #@userbusscitystateVal = params[:textBussCity]
      @userbussCity = params[:textBussCity]
      @userbussState = params[:textBussState]
      #if(!@userbusscitystateVal.blank?)
      #  @userbusscitystateVal = @userbusscitystateVal.split(',')
      #  @userbussCity = @userbusscitystateVal.at(0).strip()
      #  @userbussState = @userbusscitystateVal.at(1).strip()
      #end
      @userbussZipCode = params[:textBussZipCode]

      @usermailStreetAddress = params[:textMailStreetAddress]
      #@usermailcitystateVal = params[:textMailCity]
      @usermailCity = params[:textMailCity]
      @usermailState = params[:textMailState]
      #if(!@usermailcitystateVal.blank?)
      #  @usermailcitystateVal = @usermailcitystateVal.split(',')
      #  @usermailCity = @usermailcitystateVal.at(0).strip()
      #  @usermailState = @usermailcitystateVal.at(1).strip()
      #end
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
          ContactNumber: @subUser.ContactNumber, LicenseNumber: @subUser.LicenseNumber, AuthCodeUsed: @subUser.AuthCodeUsed, IsActivated: @subUser.IsActivated, IsSubscribed: @subUser.IsSubscribed, IsNotification: @subUser.IsNotification, 
          DateCreated: time, DateUpdated: time)        
          @subscribedUser.save
          
      #Save Address Details
      @userBussAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress1.UserID, AddressType: @subAddress1.AddressType, Address: @subAddress1.Address, City: @subAddress1.City, State: @subAddress1.State, ZipCode: @subAddress1.ZipCode, DateCreated: time, DateUpdated: time)
      @userBussAddressDetail.save
        
      @userMailAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress2.UserID, AddressType: @subAddress2.AddressType , Address: @subAddress2.Address, City: @subAddress2.City, State: @subAddress2.State, ZipCode: @subAddress2.ZipCode, DateCreated: time, DateUpdated: time)
      @userMailAddressDetail.save
      
    end
  end
  
  def DeleteUser
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
      @subUser = SubscribedUser.find_by(ID: @userID)
      @subAddress1 = UserAddressDetail.find_by(UserID: @userID, AddressType: 'Business')
      @subAddress2 = UserAddressDetail.find_by(UserID: @userID, AddressType: 'Mailing')
      @subAddressHistory1 = UserAddressDetailHistory.find_by(UserID: @userID, AddressType: 'Business')
      @subAddressHistory2 = UserAddressDetailHistory.find_by(UserID: @userID, AddressType: 'Mailing')
      
      if(!@subAddress1.blank?)
        @subAddress1.delete
      end
      
      if(!@subAddress2.blank?)
        @subAddress2.delete
      end
      
      if(!@subUser.blank?)
        @subUser.delete
      end
      
      redirect_to users_ManageUsers_url
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
      
      @subscribedUser = SubscribedUserHistory.new(ReportID: @adminActivity.id, UserID: @subUser.id, UserName: @subUser.UserName, Password: @subUser.Password, Salt: @subUser.Salt, FirstName: @subUser.FirstName,
          LastName: @subUser.LastName, EmailID: @subUser.EmailID, CompanyName: @subUser.CompanyName, IncorporationType: @subUser.IncorporationType,
          ContactNumber: @subUser.ContactNumber, LicenseNumber: @subUser.LicenseNumber, AuthCodeUsed: @subUser.AuthCodeUsed, IsActivated: @subUser.IsActivated, IsSubscribed: @subUser.IsSubscribed, IsNotification: @subUser.IsNotification, 
          DateCreated: time, DateUpdated: time)        
          @subscribedUser.save
          
      #Save Address Details
      @userBussAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress1.UserID, AddressType: @subAddress1.AddressType, Address: @subAddress1.Address, City: @subAddress1.City, State: @subAddress1.State, ZipCode: @subAddress1.ZipCode, DateCreated: time, DateUpdated: time)
      @userBussAddressDetail.save
        
      @userMailAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress2.UserID, AddressType: @subAddress2.AddressType , Address: @subAddress2.Address, City: @subAddress2.City, State: @subAddress2.State, ZipCode: @subAddress2.ZipCode, DateCreated: time, DateUpdated: time)
      @userMailAddressDetail.save
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
      else
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '106', TaskID: @subUser.id, DateCreated: time)
        @adminActivity.save
      end
      
      @subscribedUser = SubscribedUserHistory.new(ReportID: @adminActivity.id, UserID: @subUser.id, UserName: @subUser.UserName, Password: @subUser.Password, Salt: @subUser.Salt, FirstName: @subUser.FirstName,
          LastName: @subUser.LastName, EmailID: @subUser.EmailID, CompanyName: @subUser.CompanyName, IncorporationType: @subUser.IncorporationType,
          ContactNumber: @subUser.ContactNumber, LicenseNumber: @subUser.LicenseNumber, AuthCodeUsed: @subUser.AuthCodeUsed, IsActivated: @subUser.IsActivated, IsSubscribed: @subUser.IsSubscribed, IsNotification: @subUser.IsNotification, 
          DateCreated: time, DateUpdated: time)        
          @subscribedUser.save
      
      @subAddress1 = UserAddressDetail.find_by(UserID: @userID, AddressType: 'Business')
      @subAddress2 = UserAddressDetail.find_by(UserID: @userID, AddressType: 'Mailing')
          
      #Save Address Details
      @userBussAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress1.UserID, AddressType: @subAddress1.AddressType, Address: @subAddress1.Address, City: @subAddress1.City, State: @subAddress1.State, ZipCode: @subAddress1.ZipCode, DateCreated: time, DateUpdated: time)
      @userBussAddressDetail.save
        
      @userMailAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress2.UserID, AddressType: @subAddress2.AddressType , Address: @subAddress2.Address, City: @subAddress2.City, State: @subAddress2.State, ZipCode: @subAddress2.ZipCode, DateCreated: time, DateUpdated: time)
      @userMailAddressDetail.save
    end
  end
  
  def SearchNotification
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
      @status = params[:hidNotification]
      @subUser = SubscribedUser.find_by(ID: @userID)
      @subUser.IsNotification = @status.to_i
      @subUser.DateUpdated = time
      @subUser.save

      if(@status.to_i == 1)
        @userfirstName = @subUser.FirstName
        @userlastName = @subUser.LastName
        @useremail = @subUser.EmailID
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '134', TaskID: @subUser.id, DateCreated: time)
        @adminActivity.save
      else
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '135', TaskID: @subUser.id, DateCreated: time)
        @adminActivity.save
      end
      
      @subscribedUser = SubscribedUserHistory.new(ReportID: @adminActivity.id, UserID: @subUser.id, UserName: @subUser.UserName, Password: @subUser.Password, Salt: @subUser.Salt, FirstName: @subUser.FirstName,
          LastName: @subUser.LastName, EmailID: @subUser.EmailID, CompanyName: @subUser.CompanyName, IncorporationType: @subUser.IncorporationType,
          ContactNumber: @subUser.ContactNumber, LicenseNumber: @subUser.LicenseNumber, AuthCodeUsed: @subUser.AuthCodeUsed, IsActivated: @subUser.IsActivated, IsSubscribed: @subUser.IsSubscribed, IsNotification: @subUser.IsNotification,
          DateCreated: time, DateUpdated: time)        
          @subscribedUser.save
      
      @subAddress1 = UserAddressDetail.find_by(UserID: @userID, AddressType: 'Business')
      @subAddress2 = UserAddressDetail.find_by(UserID: @userID, AddressType: 'Mailing')
          
      #Save Address Details
      @userBussAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress1.UserID, AddressType: @subAddress1.AddressType, Address: @subAddress1.Address, City: @subAddress1.City, State: @subAddress1.State, ZipCode: @subAddress1.ZipCode, DateCreated: time, DateUpdated: time)
      @userBussAddressDetail.save
        
      @userMailAddressDetail = UserAddressDetailHistory.new(ReportID: @adminActivity.id, UserID: @subAddress2.UserID, AddressType: @subAddress2.AddressType , Address: @subAddress2.Address, City: @subAddress2.City, State: @subAddress2.State, ZipCode: @subAddress2.ZipCode, DateCreated: time, DateUpdated: time)
      @userMailAddressDetail.save
    end
  end
end