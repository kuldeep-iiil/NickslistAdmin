class ReviewRequest < ApplicationController
  def SendReviewRequest
    @searchReview = CustomerReviewJoin.find_by_sql("select id, CustomerSearchID, UserID, DateCreated from customer_review_joins where IsReviewGiven = '0' and IsRequestSent = '0' and DATEDIFF(NOW(), DateCreated) >= 14")
    
    @searchReview.each do |custSearch|
      @search = CustomerSearch.find_by_sql("select cs.FirstName, cs.LastName, ca.StreetAddress, ca.City, ca.State, ca.ZipCode, cp.ContactNumber
                from customer_searches cs join customer_addresses ca on cs.AddressID = ca.id
                join customer_phones cp on cs.id = cp.CustomerSearchID where cs.id = '" + custSearch.CustomerSearchID.to_s + "'")
      @firstName = @search[0].FirstName
      @lastName = @search[0].LastName
      @phoneNumber = @search[0].ContactNumber
      @streetAddress = @search[0].StreetAddress
      @zipCode = @search[0].ZipCode
      @cityState = @search[0].City + ", " + @search[0].State
      @searchDate = custSearch.DateCreated

      @subscribedUser = SubscribedUser.find_by(ID: custSearch.UserID)
      @userfirstName = @subscribedUser.FirstName
      @userlastName = @subscribedUser.LastName
      @userEmail = @subscribedUser.EmailID
      
      mail_to_user = UserMailer.ReviewRequest(@userfirstName, @userlastName, @userEmail, @firstName, @lastName, @phoneNumber, @streetAddress, @zipCode, @cityState, @searchDate)
      mail_to_user.deliver
      @updateSearchReview = CustomerReviewJoin.find_by(id: custSearch.id)
      @updateSearchReview.IsRequestSent = '1'
      @updateSearchReview.save
    end
  end
end