class UserMailer < ActionMailer::Base
  skip_before_action :verify_authenticity_token
  default from: 'no_reply@nickslist.com'
  
  def ForgotPassword(email_to, email_password)         
      @password = email_password      
      email_subject = "Password details for the Nicklists Admin login account"        
      @email_message = "Your password is :" + email_password
      mail(to: email_to, subject: email_subject)  
  end 
  
  def UserActivation(userfirstName, userlastName, userEmail)         
      @userfirstName = userfirstName
      @userlastName = userlastName
      @userEmail = userEmail
      email_to = userEmail      
      email_subject = "Welcome to Nickslist!"
      mail(to: email_to, subject: email_subject)  
  end 
  
  def ReviewPublished(userfirstName, userlastName, userEmail, firstName, lastName, phoneNumber, streetAddress, zipCode, cityState)
      @userfirstName = userfirstName
      @userlastName = userlastName
      @userEmail = userEmail
      @firstName = firstName
      @lastName = lastName
      @phoneNumber = phoneNumber
      @streetAddress = streetAddress
      @zipCode = zipCode
      @cityState = cityState
      email_to = userEmail    
      email_subject = "Review Notification"
      mail(to: email_to, subject: email_subject)  
  end
  
  def ReviewRequest(userfirstName, userlastName, userEmail, firstName, lastName, phoneNumber, streetAddress, zipCode, cityState, searchDate)
      @userfirstName = userfirstName
      @userlastName = userlastName
      @userEmail = userEmail
      @firstName = firstName
      @lastName = lastName
      @phoneNumber = phoneNumber
      @streetAddress = streetAddress
      @zipCode = zipCode
      @cityState = cityState
      @searchDate = searchDate
      email_to = userEmail    
      email_subject = "Review Notification"
      mail(to: email_to, subject: email_subject)  
  end
end
