class AuthenticationController < ApplicationController
  skip_before_action :verify_authenticity_token
  def login
    userName = params[:textUserName]
    password = params[:textPassword]
    @redirectUrl = params[:hidredirectUrl]
    @username = userName
    user = authenticate(userName, password)
    @user = user
    if user
      session[:last_seen] = Time.now
      session[:user_id] = user.id
      #session[:user_name] = user.FirstName + " " + user.LastName
      session[:user_name] = "Hi, " + user.FirstName
      
      @adminLogin = AdminLoginReport.find_by(UserID: user.id)
      if(@adminLogin.blank?)
        @adminLogin = AdminLoginReport.new(UserID: user.id, LoginDateTime: Time.now)
        @adminLogin.save
      else
        @adminLogin.LoginDateTime = Time.now
        @adminLogin.LogOutDateTime = 'NULL'
        @adminLogin.save
      end
      
      @adminLoginHistory = AdminLoginReportHistory.new(UserID: user.id, LoginDateTime: Time.now)
      @adminLoginHistory.save
      
      if(@redirectUrl.blank?)
        redirect_to root_url
      else
        redirect_to @redirectUrl
      end
    else
      redirect_to root_url, flash:{:userName => @username, :error => "Invalid User Name or Password!"}
    end
  end
  
  def logout
    userID = session[:user_id]   
    @adminLogin = AdminLoginReport.find_by(UserID: userID)
    if(!@adminLogin.blank?)
      @adminLogin.LogOutDateTime = Time.now
      @adminLogin.save
      @adminLoginHistory = AdminLoginReportHistory.find_by(UserID: userID, LoginDateTime: @adminLogin.LoginDateTime)
      if(!@adminLoginHistory.blank?)
        @adminLoginHistory.LogOutDateTime = Time.now
        @adminLoginHistory.save
      end    
    end
    
    session[:user_id] = nil
    session[:user_name] = nil
    redirect_to root_url
  end
  
  def requestpassword
    email_id = params[:textEmail]
    @messageString = ""
    if(!email_id.blank?)
      email = SiteUser.find_by(EmailID: email_id)
      if(email.blank?)
        redirect_to authentication_requestpassword_url, :notice => "Email ID is not valid!"
        return false
      else
        encryptedpassword = AuthenticationController.new()
        email_password = encryptedpassword.password_decryption(email.Password, email.Salt)      
        mail = UserMailer.ForgotPassword(email_id, email_password)
        mail.deliver        
        @messageString = "Thank you for submitting your request. Your password will be sent to you by email."
      end
    end 
  end
  
  def ChangePassword
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => authentication_SavePassword_url}
    end
  end
  
  def SavePassword
    @userID = session[:user_id]
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
    if(!@userID.blank?)
      @siteUser = SiteUser.find_by(ID: @userID)
      
      @oldPass = params[:textOldPassword]
      @newPass = params[:textPassword]

      if(password_decryption(@siteUser.Password, @siteUser.Salt) == @oldPass)
        if(password_decryption(@siteUser.Password, @siteUser.Salt) != @newPass)
          @siteUser.Password = password_encryption(@newPass, @siteUser.Salt)
          @siteUser.save
        else
          @error = "Old password can not be use to create a new password!"
        end
      else
        @error = "Old password is invalid!"
      end    
    end
    if(!@error.blank?)
      redirect_to authentication_ChangePassword_url, :notice => @error
    else    
      redirect_to user_profile_ViewProfile_url, :notice => "Password changed successfuly!"
    end 
  end
  
  def authenticate(userName, password)
   
    user = SiteUser.find_by(UserName: userName)

    if (user && password == password_decryption(user.Password, user.Salt) && user.IsActivated)
      user
    else
      nil
    end
  end

  def password_encryption(password, salt)
    pass_phrase = "userpassword"
    encrypter = OpenSSL::Cipher::Cipher.new 'AES-128-CBC'
    encrypter.encrypt
    encrypter.pkcs5_keyivgen pass_phrase, salt
    encrypted = encrypter.update password
    encrypted << encrypter.final
    password = encrypted    
    return password
  end
  
  def password_decryption(password, salt)
    pass_phrase = "userpassword"
    decrypter = OpenSSL::Cipher::Cipher.new 'AES-128-CBC'
    decrypter.decrypt
    decrypter.pkcs5_keyivgen pass_phrase, salt
    decrypted = decrypter.update password
    decrypted << decrypter.final
    password = decrypted    
    return password
  end

end
  