class ReviewsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def ManageReviews
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
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
      @queryDate = "DateCreated BETWEEN '" + @DateFrom + "' AND '" + @DateTo + "'"
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
      @queryStatus = "IsApproved = '1'"
    elsif(@filterString == '2')
      @queryStatus = "IsApproved = '0'"
    elsif(@filterString == '3')
      @queryStatus = "IsPublished = '1'"
    elsif(@filterString == '4')
      @queryStatus = "IsPublished = '0'"
    end
    
    if(@queryStatus != "" && @queryDate != "")
      @reviews = Review.find_by_sql("SELECT distinct * FROM Reviews where " + @queryDate + " and " + @queryStatus)
    elsif(@queryStatus == "" && @queryDate != "")
      @reviews = Review.find_by_sql("SELECT distinct * FROM Reviews where " + @queryDate)
    elsif(@queryStatus != "" && @queryDate == "")
      @reviews = Review.find_by_sql("SELECT distinct * FROM Reviews where " + @queryStatus)
    else
      @reviews = Review.find_by_sql("SELECT distinct * FROM Reviews")
    end 
  end
  
  def EditReview
    
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @reviewID = params[:hidReviewID]
    @reviewQuestion = ReviewQuestion.all
    @reviews = Review.find_by(ID: @reviewID)
    @reviewAnswers = ReviewAnswer.where("ReviewID = (?)", @reviewID)
    
  end
  
  def UpdateReview
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
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
    @reviewAnswer = ReviewAnswerHistory.new(ID: @reviewAnswerUpdate.ID, ReviewID: @reviewAnswerUpdate.ReviewID, QuestionID: @reviewAnswerUpdate.QuestionID, Comments: @reviewAnswerUpdate.Comments, IsYes: @reviewAnswerUpdate.IsYes, DateCreated: @reviewAnswerUpdate.DateCreated, DateUpdated: @reviewAnswerUpdate.DateUpdated)
    @reviewAnswer.save

    @reviewAnswerUpdate.Comments = @quesComment17
    @reviewAnswerUpdate.DateUpdated = time
    @reviewAnswerUpdate.save
    
    redirect_to reviews_ManageReviews_url, :notice => "Review updated successfuly!"   
    
  end
  
  def PublishReview
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reviews_ManageReviews_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @reviewID = params[:hidReviewID]
    @isPublish = params[:hidIsPublish]
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
    
    @reviews = Review.find_by(ID: @reviewID)
    @reviews.IsPublished = @isPublish.to_i
    @reviews.DateUpdated = time
    @reviews.save
  end
  
  def ApproveReview
    @moduleID = SiteModule.find_by(Module: 'Manage Reviews')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.ID, UserID: session[:user_id]).count
    
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
