class SitecontentController < ApplicationController
  skip_before_action :verify_authenticity_token
  def EditAboutPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_EditAboutPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @siteContent = SiteContent.find_by(PageCode: 101)
    if(!@siteContent.blank?)
      @title = @siteContent.Title
      @content = @siteContent.Content
      @contentID = @siteContent.id
    end
  end
  
  def EditHowItWorksPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_EditHowItWorksPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @siteContent = SiteContent.find_by(PageCode: 102)
    if(!@siteContent.blank?)
      @title = @siteContent.Title
      @content = @siteContent.Content
      @contentID = @siteContent.id
    end
  end
  
  def EditPressReleasePage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_EditPressReleasePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @siteContent = SiteContent.find_by(PageCode: 103)
    if(!@siteContent.blank?)
      @title = @siteContent.Title
      @content = @siteContent.Content
      @contentID = @siteContent.id
    end
  end
  
  def EditPrivacyPolicy
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_EditPressReleasePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @siteContent = SiteContent.find_by(PageCode: 104)
    if(!@siteContent.blank?)
      @title = @siteContent.Title
      @content = @siteContent.Content
      @contentID = @siteContent.id
    end
  end
  
  def EditTermsConditions
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_EditPressReleasePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @siteContent = SiteContent.find_by(PageCode: 105)
    if(!@siteContent.blank?)
      @title = @siteContent.Title
      @content = @siteContent.Content
      @contentID = @siteContent.id
    end
  end
  
  def UpdateSiteContent
    @contentID = params[:hidContentID]
    @siteContent = SiteContent.find_by(id: @contentID)
    @editPageURL = params[:hidEditPageUrl]
    if(!@siteContent.blank?)
      @siteContent.Content = params[:textContent]
      @siteContent.Title = params[:textTitle]
      @siteContent.save
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
    end
    
    @faqList = Faq.all
  end
  
   def EditFAQPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageFAQPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @faqID = params[:hidFAQID]
    @faq = Faq.find_by(id: @faqID)
    if(!@faq.blank?)
      @question = @faq.Question
      @answer = @faq.Answers
    end
  end
  
  def AddUpdateFAQPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
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
      @result = "FAQ updated successfuly!"
    else
      @faq = Faq.new(Question: @question, Answers: @answers, IsEnabled: 1, DateCreated: time,  DateUpdated: time)
      @faq.save
      @result = "FAQ added successfuly!"
    end
    
    redirect_to sitecontent_ManageFAQPage_url, :notice => @result    
  end
  
  def DeleteFAQPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageFAQPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @faqID = params[:hidFAQID]
    @faq = Faq.find_by(id: @faqID)
    if(!@faq.blank?)
      @faq.delete
    end
    
    redirect_to sitecontent_ManageFAQPage_url, :notice => "Record deleted Succesfuly"   
  end
  
  def EnableDisableFAQ
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageFAQPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @faqID = params[:hidFAQID]
    @isEnabled = params[:hidEnable]
    @faq = Faq.find_by(id: @faqID)
    if(!@faq.blank?)
      @faq.IsEnabled = @isEnabled
      @faq.save
    end
  end
  
  def ManageTestimonialsPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageTestimonialsPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @testimonialList = Testimonials.all
    if(!@testimonialList.blank?)
      @count = @testimonialList.length
    else
      @count = 0
    end
    
  end
  
  def EditTestimonialsPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageTestimonialsPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @testID = params[:hidTestID]
    @testimonial = Testimonials.find_by(id: @testID)
    if(!@testimonial.blank?)
      @firstName = @testimonial.FirstName
      @lastName = @testimonial.LastName
      @occupation = @testimonial.Occupation
      @comments = @testimonial.Comments
    end
  end
  
  def AddUpdateTestimonialsPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
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
      @result = "Testimonial updated successfuly!"
    else
      @testimonial = Testimonials.new(FirstName: @firstName, LastName: @lastName, Occupation: @occupation, Comments: @comments, IsEnabled: 1, DateCreated: time,  DateUpdated: time)
      @testimonial.save
      @result = "Testimonial added successfuly!"
    end
    
    redirect_to sitecontent_ManageTestimonialsPage_url, :notice => @result      
  end
  
  def DeleteTestimonialsPage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageTestimonialsPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @testID = params[:hidTestID]
    @testimonial = Testimonials.find_by(id: @testID)
    if(!@testimonial.blank?)
      @testimonial.delete
    end
    redirect_to sitecontent_ManageTestimonialsPage_url, :notice => "Record deleted successfuly!"
  end
  
  def EnableDisableTestimonials
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageTestimonialsPage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @testID = params[:hidTestID]
    @isEnabled = params[:hidEnable]
    @testimonial = Testimonials.find_by(id: @testID)
    if(!@testimonial.blank?)
      @testimonial.IsEnabled = @isEnabled
      @testimonial.save
    end
  end  
    
  def ManageNewsUpdatePage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @newsUpdatesList = NewsUpdates.all
  end
  
  def EditNewsUpdatePage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @newID = params[:hidNewID] 
    @newsUpdates = NewsUpdates.find_by(id: @newID)
    if(!@newsUpdates.blank?)
      @comments = @newsUpdates.Comments
    end  
  end
  
  def AddUpdateNewsUpdatePage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    
    @newID = params[:hidNewID]
    @comments = params[:textComment]    
    currentTime = Time.new
    time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
    
    @newsUpdates = NewsUpdates.find_by(id: @newID)
    if(!@newsUpdates.blank?)
      @newsUpdates.Comments = @comments
      @newsUpdates.save
      @result = "News&Update updated successfuly!"
    else
      @newsUpdates = NewsUpdates.new(Comments: @comments, IsEnabled: 1, DateCreated: time,  DateUpdated: time)
      @newsUpdates.save
      @result = "News&Update added successfuly!"
    end
    
    redirect_to sitecontent_ManageNewsUpdatePage_url, :notice => @result     
  end
  
  def DeleteNewsUpdatePage
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @newID = params[:hidNewID] 
    @newsUpdates = NewsUpdates.find_by(id: @newID)
    if(!@newsUpdates.blank?)
      @newsUpdates.delete
    end 
    
    redirect_to sitecontent_ManageNewsUpdatePage_url, :notice => "Record deleted successfuly!"   
  end
  
  def EnableDisableNewsUpdate
    @moduleID = SiteModule.find_by(Module: 'Manage Site Content')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => sitecontent_ManageNewsUpdatePage_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
    @newID = params[:hidNewID]
    @isEnabled = params[:hidEnable] 
    @newsUpdates = NewsUpdates.find_by(id: @newID)
    if(!@newsUpdates.blank?)
      @newsUpdates.IsEnabled = @isEnabled
      @newsUpdates.save
    end 
  end  
end