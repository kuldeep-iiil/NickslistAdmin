class SitecontentController < ApplicationController
  skip_before_action :verify_authenticity_token
  def EditAboutPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_EditAboutPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @siteContent = SiteContent.find_by(PageCode: 101)
      if(!@siteContent.blank?)
        @title = @siteContent.Title
        @content = @siteContent.Content
        @contentID = @siteContent.id
      end
    end
  end

  def EditHowItWorksPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_EditHowItWorksPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @siteContent = SiteContent.find_by(PageCode: 102)
      if(!@siteContent.blank?)
        @title = @siteContent.Title
        @content = @siteContent.Content
        @contentID = @siteContent.id
      end
    end
  end

  def EditPressReleasePage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_EditPressReleasePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @siteContent = SiteContent.find_by(PageCode: 103)
      if(!@siteContent.blank?)
        @title = @siteContent.Title
        @content = @siteContent.Content
        @contentID = @siteContent.id
      end
    end
  end

  def EditPrivacyPolicy
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_EditPressReleasePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @siteContent = SiteContent.find_by(PageCode: 104)
      if(!@siteContent.blank?)
        @title = @siteContent.Title
        @content = @siteContent.Content
        @contentID = @siteContent.id
      end
    end
  end

  def EditTermsConditions
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_EditPressReleasePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @siteContent = SiteContent.find_by(PageCode: 105)
      if(!@siteContent.blank?)
        @title = @siteContent.Title
        @content = @siteContent.Content
        @contentID = @siteContent.id
      end
    end
  end

  def UpdateSiteContent
    
    currentUserID = session[:user_id]
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
    @contentID = params[:hidContentID]
    @siteContent = SiteContent.find_by(id: @contentID)
    @editPageURL = params[:hidEditPageUrl]
    if(!@siteContent.blank?)
      @siteContent.Content = params[:textContent]
      @siteContent.Title = params[:textTitle]
      @siteContent.save
      @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '116', TaskID: @siteContent.id, DateCreated: time)
      @adminActivity.save
      
      @siteContentHistory = SiteContentHistory.new(ReportID: @adminActivity.id, PageCode: @siteContent.PageCode, Title: @siteContent.Title, Content: @siteContent.Content, IsEnabled: @siteContent.IsEnabled, DateCreated: time, DateUpdated: time)
      @siteContentHistory.save
    end

    redirect_to @editPageURL, :notice => "Page content updated successfuly!"
  end

  def ManageFAQPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageFAQPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @faqList = Faq.all
    end
  end

  def EditFAQPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageFAQPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @faqID = params[:hidFAQID]
      @faq = Faq.find_by(id: @faqID)
      if(!@faq.blank?)
        @question = @faq.Question
        @answer = @faq.Answers
      end
    end
  end

  def AddUpdateFAQPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      @faqID = params[:hidFAQID]
      @question = params[:textQuestion]
      @answers = params[:textAnswer]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")

      @faq = Faq.find_by(id: @faqID)
      if(!@faq.blank?)
        @faq.Question = @question
        @faq.Answers = @answers
        @faq.save
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '118', TaskID: @faq.id, DateCreated: time)
        @adminActivity.save
        
        @faqHistory = FaqHistory.new(ReportID: @adminActivity.id, Question: @faq.Question, Answers: @faq.Answers, IsEnabled: @faq.IsEnabled, DateCreated: time,  DateUpdated: time)
        @faqHistory.save
        @result = "FAQ updated successfuly!"
      else
        @faq = Faq.new(Question: @question, Answers: @answers, IsEnabled: 1, DateCreated: time,  DateUpdated: time)
        @faq.save
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '117', TaskID: @faq.id, DateCreated: time)
        @adminActivity.save
        
        @faqHistory = FaqHistory.new(ReportID: @adminActivity.id, Question: @faq.Question, Answers: @faq.Answers, IsEnabled: @faq.IsEnabled, DateCreated: time,  DateUpdated: time)
        @faqHistory.save
        @result = "FAQ added successfuly!"
      end

      redirect_to sitecontent_ManageFAQPage_url, :notice => @result
    end
  end

  def DeleteFAQPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageFAQPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      
      @faqID = params[:hidFAQID]
      @faq = Faq.find_by(id: @faqID)
      if(!@faq.blank?)
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '119', TaskID: @faq.id, DateCreated: time)
        @adminActivity.save
        
        @faqHistory = FaqHistory.new(ReportID: @adminActivity.id, Question: @faq.Question, Answers: @faq.Answers, IsEnabled: @faq.IsEnabled, DateCreated: time,  DateUpdated: time)
        @faqHistory.save
        
        @faq.delete
        
      end

      redirect_to sitecontent_ManageFAQPage_url, :notice => "Record deleted Succesfuly"
    end
  end

  def EnableDisableFAQ
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageFAQPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      
      @faqID = params[:hidFAQID]
      @isEnabled = params[:hidEnable]
      @faq = Faq.find_by(id: @faqID)
      if(!@faq.blank?)
        @faq.IsEnabled = @isEnabled
        @faq.save
        
        if(@isEnabled.to_i == 1)
          @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '120', TaskID: @faq.id, DateCreated: time)
          @adminActivity.save
          
          @faqHistory = FaqHistory.new(ReportID: @adminActivity.id, Question: @faq.Question, Answers: @faq.Answers, IsEnabled: @faq.IsEnabled, DateCreated: time,  DateUpdated: time)
          @faqHistory.save
        else
          @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '121', TaskID: @faq.id, DateCreated: time)
          @adminActivity.save
          
          @faqHistory = FaqHistory.new(ReportID: @adminActivity.id, Question: @faq.Question, Answers: @faq.Answers, IsEnabled: @faq.IsEnabled, DateCreated: time,  DateUpdated: time)
          @faqHistory.save
        end
      end
    end
  end

  def ManageTestimonialsPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageTestimonialsPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @testimonialList = Testimonials.all
      if(!@testimonialList.blank?)
        @count = @testimonialList.length
      else
        @count = 0
      end
    end
  end

  def EditTestimonialsPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageTestimonialsPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @testID = params[:hidTestID]
      @testimonial = Testimonials.find_by(id: @testID)
      if(!@testimonial.blank?)
        @firstName = @testimonial.FirstName
        @lastName = @testimonial.LastName
        @occupation = @testimonial.Occupation
        @comments = @testimonial.Comments
      end
    end
  end

  def AddUpdateTestimonialsPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      
      @testID = params[:hidTestID]
      @firstName = params[:textFirstName]
      @lastName = params[:textLastName]
      @occupation = params[:textOccupation]
      @comments = params[:textComment]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")

      @testimonial = Testimonials.find_by(id: @testID)
      if(!@testimonial.blank?)
        @testimonial.FirstName = @firstName
        @testimonial.LastName = @lastName
        @testimonial.Occupation = @occupation
        @testimonial.Comments = @comments
        @testimonial.save
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '123', TaskID: @testimonial.id, DateCreated: time)
        @adminActivity.save
        
        @testimonialHistory = TestimonialHistory.new(ReportID: @adminActivity.id, FirstName: @testimonial.FirstName, LastName: @testimonial.LastName, Occupation: @testimonial.Occupation, Comments: @testimonial.Comments, IsEnabled: @testimonial.IsEnabled, DateCreated: time,  DateUpdated: time)
        @testimonialHistory.save
        
        @result = "Testimonial updated successfuly!"
      else
        @testimonial = Testimonials.new(FirstName: @firstName, LastName: @lastName, Occupation: @occupation, Comments: @comments, IsEnabled: 1, DateCreated: time,  DateUpdated: time)
        @testimonial.save
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '122', TaskID: @testimonial.id, DateCreated: time)
        @adminActivity.save
        
        @testimonialHistory = TestimonialHistory.new(ReportID: @adminActivity.id, FirstName: @testimonial.FirstName, LastName: @testimonial.LastName, Occupation: @testimonial.Occupation, Comments: @testimonial.Comments, IsEnabled: @testimonial.IsEnabled, DateCreated: time,  DateUpdated: time)
        @testimonialHistory.save
          
        @result = "Testimonial added successfuly!"
      end

      redirect_to sitecontent_ManageTestimonialsPage_url, :notice => @result
    end
  end

  def DeleteTestimonialsPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageTestimonialsPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      
      @testID = params[:hidTestID]
      @testimonial = Testimonials.find_by(id: @testID)
      if(!@testimonial.blank?)
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '124', TaskID: @testimonial.id, DateCreated: time)
        @adminActivity.save
        
        @testimonialHistory = TestimonialHistory.new(ReportID: @adminActivity.id, FirstName: @testimonial.FirstName, LastName: @testimonial.LastName, Occupation: @testimonial.Occupation, Comments: @testimonial.Comments, IsEnabled: @testimonial.IsEnabled, DateCreated: time,  DateUpdated: time)
        @testimonialHistory.save
        
        @testimonial.delete
        
      end
      redirect_to sitecontent_ManageTestimonialsPage_url, :notice => "Record deleted successfuly!"
    end
  end

  def EnableDisableTestimonials
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageTestimonialsPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      
      @testID = params[:hidTestID]
      @isEnabled = params[:hidEnable]
      @testimonial = Testimonials.find_by(id: @testID)
      if(!@testimonial.blank?)
        @testimonial.IsEnabled = @isEnabled
        @testimonial.save
      
        if(@isEnabled.to_i == 1)
          @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '125', TaskID: @testimonial.id, DateCreated: time)
          @adminActivity.save
        else
          @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '126', TaskID: @testimonial.id, DateCreated: time)
          @adminActivity.save
        end
        
        @testimonialHistory = TestimonialHistory.new(ReportID: @adminActivity.id, FirstName: @testimonial.FirstName, LastName: @testimonial.LastName, Occupation: @testimonial.Occupation, Comments: @testimonial.Comments, IsEnabled: @testimonial.IsEnabled, DateCreated: time,  DateUpdated: time)
        @testimonialHistory.save
      end
    end
  end

  def ManageNewsUpdatePage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @newsUpdatesList = NewsUpdates.all
    end
  end

  def EditNewsUpdatePage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @newID = params[:hidNewID]
      @newsUpdates = NewsUpdates.find_by(id: @newID)
      if(!@newsUpdates.blank?)
        @comments = @newsUpdates.Comments
      end
    end
  end

  def AddUpdateNewsUpdatePage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]

      @newID = params[:hidNewID]
      @comments = params[:textComment]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")

      @newsUpdates = NewsUpdates.find_by(id: @newID)
      if(!@newsUpdates.blank?)
        @newsUpdates.Comments = @comments
        @newsUpdates.save
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '128', TaskID: @newsUpdates.id, DateCreated: time)
        @adminActivity.save
        
        @newsUpdateHistory = NewsUpdateHistory.new(ReportID: @adminActivity.id, Comments: @newsUpdates.Comments, IsEnabled: @newsUpdates.IsEnabled, DateCreated: time,  DateUpdated: time)
        @newsUpdateHistory.save
        
        @result = "News&Update updated successfuly!"
      else
        @newsUpdates = NewsUpdates.new(Comments: @comments, IsEnabled: 1, DateCreated: time,  DateUpdated: time)
        @newsUpdates.save
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '127', TaskID: @newsUpdates.id, DateCreated: time)
        @adminActivity.save
        
        @newsUpdateHistory = NewsUpdateHistory.new(ReportID: @adminActivity.id, Comments: @newsUpdates.Comments, IsEnabled: @newsUpdates.IsEnabled, DateCreated: time,  DateUpdated: time)
        @newsUpdateHistory.save
        
        @result = "News&Update added successfuly!"
      end

      redirect_to sitecontent_ManageNewsUpdatePage_url, :notice => @result
    end
  end

  def DeleteNewsUpdatePage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      
      @newID = params[:hidNewID]
      @newsUpdates = NewsUpdates.find_by(id: @newID)
      if(!@newsUpdates.blank?)
        
        @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '129', TaskID: @newsUpdates.id, DateCreated: time)
        @adminActivity.save
        
        @newsUpdateHistory = NewsUpdateHistory.new(ReportID: @adminActivity.id, Comments: @newsUpdates.Comments, IsEnabled: @newsUpdates.IsEnabled, DateCreated: time,  DateUpdated: time)
        @newsUpdateHistory.save
        
        @newsUpdates.delete
      end

      redirect_to sitecontent_ManageNewsUpdatePage_url, :notice => "Record deleted successfuly!"
    end
  end

  def EnableDisableNewsUpdate
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      
      @newID = params[:hidNewID]
      @isEnabled = params[:hidEnable]
      @newsUpdates = NewsUpdates.find_by(id: @newID)
      if(!@newsUpdates.blank?)
        @newsUpdates.IsEnabled = @isEnabled
        @newsUpdates.save
      
        if(@isEnabled.to_i == 1)
          @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '130', TaskID: @newsUpdates.id, DateCreated: time)
          @adminActivity.save
        else
          @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '131', TaskID: @newsUpdates.id, DateCreated: time)
          @adminActivity.save
        end
        
        @newsUpdateHistory = NewsUpdateHistory.new(ReportID: @adminActivity.id, Comments: @newsUpdates.Comments, IsEnabled: @newsUpdates.IsEnabled, DateCreated: time,  DateUpdated: time)
        @newsUpdateHistory.save
      end
    end
  end
end