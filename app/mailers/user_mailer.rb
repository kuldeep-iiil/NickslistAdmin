class UserMailer < ActionMailer::Base
  skip_before_action :verify_authenticity_token
  default from: 'kuldeep.it2008@gmail.com'
  
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
end
