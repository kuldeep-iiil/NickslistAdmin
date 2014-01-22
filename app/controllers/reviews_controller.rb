class ReviewsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def ManageReviews
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

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
  end

  def EditReview

    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
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
  end

  def PublishReview
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      
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
      
      @reviewAnswers = ReviewAnswer.find_by_sql("select * from review_answers where ReviewID = '" + @reviewID.to_s + "'");
      
      if(@isPublish.to_i == 2)
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '110', TaskID: @reviews.id, DateCreated: time)
        @adminActivity.save
        
        if(!@reviewAnswers.blank?)
          @reviewAnswers.each do |revAns|
            @rptReviewAnswersHistory = ReviewAnswerHistoryReport.new(ReportID: @adminActivity.id, ReviewID: revAns.ReviewID, QuestionID: revAns.QuestionID, Comments: revAns.Comments, IsYes: revAns.IsYes.to_s, DateCreated: time, DateUpdated: time)
            @rptReviewAnswersHistory.save
          end
        end
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '112', TaskID: @reviews.id, DateCreated: time)
        @adminActivity.save
        
        if(!@reviewAnswers.blank?)
          @reviewAnswers.each do |revAns|
            @rptReviewAnswersHistory = ReviewAnswerHistoryReport.new(ReportID: @adminActivity.id, ReviewID: revAns.ReviewID, QuestionID: revAns.QuestionID, Comments: revAns.Comments, IsYes: revAns.IsYes.to_s, DateCreated: time, DateUpdated: time)
            @rptReviewAnswersHistory.save
          end
        end
        
      elsif(@isPublish.to_i == 1)
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '112', TaskID: @reviews.id, DateCreated: time)
        @adminActivity.save
        
        if(!@reviewAnswers.blank?)
          @reviewAnswers.each do |revAns|
            @rptReviewAnswersHistory = ReviewAnswerHistoryReport.new(ReportID: @adminActivity.id, ReviewID: revAns.ReviewID, QuestionID: revAns.QuestionID, Comments: revAns.Comments, IsYes: revAns.IsYes.to_s, DateCreated: time, DateUpdated: time)
            @rptReviewAnswersHistory.save
          end
        end
        
      else
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '113', TaskID: @reviews.id, DateCreated: time)
        @adminActivity.save
      
        if(!@reviewAnswers.blank?)
          @reviewAnswers.each do |revAns|
            @rptReviewAnswersHistory = ReviewAnswerHistoryReport.new(ReportID: @adminActivity.id, ReviewID: revAns.ReviewID, QuestionID: revAns.QuestionID, Comments: revAns.Comments, IsYes: revAns.IsYes.to_s, DateCreated: time, DateUpdated: time)
            @rptReviewAnswersHistory.save
          end
        end
        
      end

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

        @subscribedUser = SubscribedUser.find_by(id: @reviews.UserID)
        @userfirstName = @subscribedUser.FirstName
        @userlastName = @subscribedUser.LastName
        @userEmail = @subscribedUser.EmailID

        mail_to_user = UserMailer.ReviewPublished(@userfirstName, @userlastName, @userEmail, @firstName, @lastName, @phoneNumber, @streetAddress, @zipCode, @cityState)
        mail_to_user.deliver
      end
    end
  end

  def ApproveReview
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      
      @reviewID = params[:hidReviewID]
      @isApproved = params[:hidIsApproved]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")

      @reviews = Review.find_by(ID: @reviewID)
      @reviews.IsApproved = @isApproved.to_i
      @reviews.DateUpdated = time
      @reviews.save
      
      @reviewAnswers = ReviewAnswer.find_by_sql("select * from review_answers where ReviewID = '" + @reviewID.to_s + "'");
      
      if(@isApproved.to_i == 1)
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '110', TaskID: @reviews.id, DateCreated: time)
        @adminActivity.save
        
        if(!@reviewAnswers.blank?)
          @reviewAnswers.each do |revAns|
            @rptReviewAnswersHistory = ReviewAnswerHistoryReport.new(ReportID: @adminActivity.id, ReviewID: revAns.ReviewID, QuestionID: revAns.QuestionID, Comments: revAns.Comments, IsYes: revAns.IsYes.to_s, DateCreated: time, DateUpdated: time)
            @rptReviewAnswersHistory.save
          end
        end
        
      else
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '111', TaskID: @reviews.id, DateCreated: time)
        @adminActivity.save
        
        if(!@reviewAnswers.blank?)
          @reviewAnswers.each do |revAns|
            @rptReviewAnswersHistory = ReviewAnswerHistoryReport.new(ReportID: @adminActivity.id, ReviewID: revAns.ReviewID, QuestionID: revAns.QuestionID, Comments: revAns.Comments, IsYes: revAns.IsYes.to_s, DateCreated: time, DateUpdated: time)
            @rptReviewAnswersHistory.save
          end
        end
        
      end
    end
  end
end
