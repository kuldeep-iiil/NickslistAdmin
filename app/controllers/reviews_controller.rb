class ReviewsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def ManageReviews
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end

    @reviewQuestion = ReviewQuestion.all
    
    @query = "SELECT distinct rev.id, rev.IsPublished, rev.IsApproved, rev.DateCreated, cust.FirstName as cFirstName, cust.LastName as cLastName, suser.FirstName as sFirstName, suser.LastName as sLastName FROM reviews rev JOIN customer_searches cust on rev.CustomerSearchID = cust.id join customer_addresses custAdd on cust.AddressID = custAdd.id join customer_phones custPhone on cust.id = custPhone.CustomerSearchID JOIN subscribed_users suser on rev.UserID = suser.id join review_answers revAns on rev.id = revAns.reviewID where rev.id != ''"

    if(params[:hidSetFilter] == nil)
      @statusID = '0'
      if(params[:selectStatus] != nil)
        @statusID = params[:selectStatus]
      end

      @queryStatus = ""
      if(@statusID == '0')
        @queryStatus = ""
      elsif(@statusID == '1')
        @queryStatus = "rev.IsApproved = '1'"
      elsif(@statusID == '2')
        @queryStatus = "rev.IsApproved = '0'"
      elsif(@statusID == '3')
        @queryStatus = "rev.IsPublished = '1'"
      elsif(@statusID == '4')
        @queryStatus = "rev.IsPublished = '0'"
      end
      
      if(!@queryStatus.blank?)
        @query = @query + " and " + @queryStatus
      end

      if(params[:selectQuestion] != nil)
        @questionID = params[:selectQuestion]
        if(@questionID == '0')
          @queryQuestion = ""
        else
          @queryQuestion ="revAns.QuestionID = '" + @questionID + "'"
        end
      end

      if(!@queryQuestion.blank?)
        @query = @query + " and " + @queryQuestion
      end

      if(params[:selectAnswer] != nil)
        @answerID = params[:selectAnswer]
        if(@answerID == '1')
          @queryAnswer = "revAns.IsYes is NULL"
        elsif(@answerID == '2')
          @queryAnswer = "revAns.IsYes = 'Yes'"
        elsif(@answerID == '3')
          @queryAnswer = "revAns.IsYes = 'No'"
        else
          @queryAnswer = ""
        end
      end

      if(!@queryAnswer.blank?)
        @query = @query + " and " + @queryAnswer
      end

      @queryStatus = ""
      if(@statusID == '0')
        @queryStatus = ""
      elsif(@statusID == '1')
        @queryStatus = "rev.IsApproved = '1'"
      elsif(@statusID == '2')
        @queryStatus = "rev.IsApproved = '0'"
      elsif(@statusID == '3')
        @queryStatus = "rev.IsPublished = '1'"
      elsif(@statusID == '4')
        @queryStatus = "rev.IsPublished = '0'"
      end

      if(!@queryStatus.blank?)
        @query = @query + " and " + @queryStatus
      end

      @queryFirstName = ""
      if(params[:txtFirstName] != nil)
        @firstName = params[:txtFirstName].strip()
        if(@firstName != "")
          @queryFirstName = "cust.FirstName = '" + @firstName +"'"
          @query = @query + " and " + @queryFirstName
        end
      end

      @queryLastName = ""
      if(params[:txtLastName] != nil)
        @lastName = params[:txtLastName].strip()
        if(@lastName != "")
          @queryLastName = "cust.LastName = '" + @lastName +"'"
          @query = @query + " and " + @queryLastName
        end
      end

      @queryAddress = ""
      if(params[:txtStreetAddress] != nil)
        @streetAddress = params[:txtStreetAddress].strip()
        if(@streetAddress != "")
          @queryAddress = "custAdd.StreetAddress = '" + @streetAddress + "'"
          @query = @query + " and " + @queryAddress
        end
      end

      @queryCityState = ""
      if(params[:selectCity] != nil)
        @cityState = params[:selectCity].strip()
        if(@cityState != "")
          @citystateValSplit = @cityState.split(',')
          @queryCityState = "custAdd.City = '" + @citystateValSplit.at(0).strip() + "' and custAdd.State = '" + @citystateValSplit.at(1).strip() + "'"
          @query = @query + " and " + @queryCityState
        end
      end

      @queryZipCode = ""
      if(params[:txtZipCode] != nil)
        @zipCode = params[:txtZipCode].strip()
        if(@zipCode != "")
          @queryZipCode = "custAdd.ZipCode = '" + @zipCode + "'"
          @query = @query + " and " + @queryZipCode
        end
      end

      @queryPhone = ""
      if(params[:txtPhoneNumber] != nil)
        @phoneNumber = params[:txtPhoneNumber].strip()
        if(@phoneNumber != "")
          @queryPhone = "custPhone.ContactNumber = '" + @phoneNumber +"'"
          @query = @query + " and " + @queryPhone
        end
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
        @queryDate = "rev.DateCreated BETWEEN '" + @dateFrom + "' AND '" + @dateTo + "'"
      elsif(@dateFrom != "" && @dateTo == "")
        @queryDate = "rev.DateCreated >= '" + @dateFrom + "'"
      elsif(@dateFrom == "" && @dateTo != "")
        @queryDate = "rev.DateCreated <= '" + @dateTo + "'"
      else
        @queryDate = ""
      end

      if(!@queryDate.blank?)
        @query = @query + " and " + @queryDate
      end

      if(!@query.blank?)
        @reviews = Review.find_by_sql(@query)
      end
    else
      @reviews = Review.find_by_sql(@query)
    end
  end

  def EditReview

    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @reviewID = params[:hidReviewID]

    if(!@reviewID.blank?)
      @reviewDetails = CustomerSearch.find_by_sql("select cust.FirstName, cust.LastName, custadd.*, custphone.ContactNumber
                      from customer_addresses custadd join customer_searches cust on cust.AddressID = custadd.id
                      join customer_phones custphone on cust.id = custphone.CustomerSearchID
                      join reviews rev on cust.ID  = rev.CustomerSearchID
                      where rev.id = '" + @reviewID.to_s + "'")

      @revfirstName = @reviewDetails[0].FirstName
      @revlastName = @reviewDetails[0].LastName
      @revstreetAddress = @reviewDetails[0].StreetAddress
      @revcitystateVal = @reviewDetails[0].City + ', ' + @reviewDetails[0].State
      @revzipCode = @reviewDetails[0].ZipCode
      @revphoneNumber = @reviewDetails[0].ContactNumber
    end

    @reviewQuestion = ReviewQuestion.all
    @reviews = Review.find_by(ID: @reviewID)
    @reviewAnswers = ReviewAnswer.where("ReviewID = (?)", @reviewID)

  end

  def UpdateReview
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end

    @reviewID = params[:hidReviewID]
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")

    @quesComment1 = params[:quesComment1]
    @radYesNo1 = params[:radYesNo1]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 1)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 1)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment1
    @reviewAnswerUpdate.IsYes = @radYesNo1
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @radYesNo2 = params[:radYesNo2]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 2)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 2)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = ""
    @reviewAnswerUpdate.IsYes = @radYesNo2
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @radYesNo3 = params[:radYesNo3]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 3)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 3)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = ""
    @reviewAnswerUpdate.IsYes = @radYesNo3
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @radYesNo4 = params[:radYesNo4]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 4)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 4)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = ""
    @reviewAnswerUpdate.IsYes = @radYesNo4
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @radYesNo5 = params[:radYesNo5]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 5)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 5)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = ""
    @reviewAnswerUpdate.IsYes = @radYesNo5
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @radYesNo6 = params[:radYesNo6]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 6)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 6)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = ""
    @reviewAnswerUpdate.IsYes = @radYesNo6
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @radYesNo7 = params[:radYesNo7]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 7)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 7)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = ""
    @reviewAnswerUpdate.IsYes = @radYesNo7
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @quesComment8 = params[:quesComment8]
    @radYesNo8 = params[:radYesNo8]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 8)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 8)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment8
    @reviewAnswerUpdate.IsYes = @radYesNo8
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @quesComment9 = params[:quesComment9]
    @radYesNo9 = params[:radYesNo9]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 9)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 9)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment9
    @reviewAnswerUpdate.IsYes = @radYesNo9
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @quesComment10 = params[:quesComment10]
    @radYesNo10 = params[:radYesNo10]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 10)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 10)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment10
    @reviewAnswerUpdate.IsYes = @radYesNo10
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @quesComment11 = params[:quesComment11]
    @radYesNo11 = params[:radYesNo11]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 11)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 11)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment11
    @reviewAnswerUpdate.IsYes = @radYesNo11
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @quesComment12 = params[:quesComment12]
    @radYesNo12 = params[:radYesNo12]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 12)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 12)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment12
    @reviewAnswerUpdate.IsYes = @radYesNo12
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @quesComment13 = params[:quesComment13]
    @radYesNo13 = params[:radYesNo13]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 13)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 13)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment13
    @reviewAnswerUpdate.IsYes = @radYesNo13
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @quesComment14 = params[:quesComment14]
    @radYesNo14 = params[:radYesNo14]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 14)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 14)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment14
    @reviewAnswerUpdate.IsYes = @radYesNo14
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @quesComment15 = params[:quesComment15]
    @radYesNo15 = params[:radYesNo15]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 15)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 15)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment15
    @reviewAnswerUpdate.IsYes = @radYesNo15
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @quesComment16 = params[:quesComment16]
    @radYesNo16 = params[:radYesNo16]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 16)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 16)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment16
    @reviewAnswerUpdate.IsYes = @radYesNo16
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    @quesComment17 = params[:quesComment17]
    @reviewAnswerUpdate = ReviewAnswer.find_by(ReviewID: @reviewID, QuestionID: 17)

    @reviewAnswer = ReviewAnswerHistory.find_by(ReviewID: @reviewID, QuestionID: 17)
    if(!@reviewAnswer.blank?)
    @reviewAnswer.destroy
    end
    @reviewAnswer = ReviewAnswerHistory.new(id: @reviewAnswerUpdate.id, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment17
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save

    redirect_to reviews_ManageReviews_url, :notice => "Review updated successfuly!"

  end

  def PublishReview
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end

    @userID = session[:user_id]
    @reviewID = params[:hidReviewID]
    @isPublish = params[:hidIsPublish]
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")

    @reviews = Review.find_by(id: @reviewID)
    if(@isPublish.to_i == 2)
    @reviews.IsApproved = 1
    @reviews.IsPublished = 1
    @reviews.DateUpdated = time
    else
    @reviews.IsPublished = @isPublish.to_i
    @reviews.DateUpdated = time
    end
    @reviews.save

    if(@isPublish.to_i == 1)
      @searchID = @reviews.CustomerSearchID
      @search = CustomerSearch.find_by_sql("select cs.FirstName, cs.LastName, ca.StreetAddress, ca.City, ca.State, ca.ZipCode, cp.ContactNumber
                from customer_searches cs join customer_addresses ca on cs.AddressID = ca.id
                join customer_phones cp on cs.id = cp.CustomerSearchID where cs.id = " + @searchID.to_s)
      @firstName = @search[0].FirstName
      @lastName = @search[0].LastName
      @phoneNumber = @search[0].ContactNumber
      @streetAddress = @search[0].StreetAddress
      @zipCode = @search[0].ZipCode
      @cityState = @search[0].City + ", " + @search[0].State

      @subscribedUser = SubscribedUser.find_by(ID: @userID)
      @userfirstName = @subscribedUser.FirstName
      @userlastName = @subscribedUser.LastName
      @userEmail = @subscribedUser.EmailID

      mail_to_user = UserMailer.ReviewPublished(@userfirstName, @userlastName, @userEmail, @firstName, @lastName, @phoneNumber, @streetAddress, @zipCode, @cityState)
    mail_to_user.deliver
    end
  end

  def ApproveReview
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end

    @reviewID = params[:hidReviewID]
    @isApproved = params[:hidIsApproved]
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")

    @reviews = Review.find_by(ID: @reviewID)
    @reviews.IsApproved = @isApproved.to_i
    @reviews.DateUpdated = time
    @reviews.save
  end
end
