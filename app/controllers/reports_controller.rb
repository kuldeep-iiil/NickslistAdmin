class ReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def UserLoginReport
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_UserLoginReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @userLoginDetails = SubscribedUser.find_by_sql("SELECT distinct subUser.id, subUser.FirstName, subUser.LastName, subUser.UserName, userLogin.LoginDateTime, userLogin.LogOutDateTime
                  FROM subscribed_users subUser LEFT JOIN user_login_reports userLogin ON subUser.id = userLogin.UserID")
    end
  end

  def AdminLoginReport
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminLoginReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @adminLoginDetails = SiteUser.find_by_sql("SELECT distinct adminUser.id, adminUser.FirstName, adminUser.LastName, adminUser.UserName, adminLogin.LoginDateTime, adminLogin.LogOutDateTime
                  FROM site_users adminUser LEFT JOIN admin_login_reports adminLogin ON adminUser.id = adminLogin.UserID")
    end
  end

  def ViewUserLoginHistory
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_UserLoginReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @userID = params[:hidUserID]
      @subUser = SubscribedUser.find_by(ID: @userID)
      if(!@subUser.blank?)
        @userFirstName = @subUser.FirstName
        @userLastName = @subUser.LastName
        @userUserName = @subUser.UserName
      end
      @userLoginDetails = SubscribedUser.find_by_sql("SELECT distinct subUser.id, userLogin.LoginDateTime, userLogin.LogOutDateTime
                  FROM subscribed_users subUser LEFT JOIN user_login_report_histories userLogin ON subUser.id = userLogin.UserID where userLogin.UserID = '" + @userID + "'")
    end
  end

  def ViewAdminLoginHistory
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminLoginReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @userID = params[:hidUserID]
      @siteUser = SiteUser.find_by(ID: @userID)
      if(!@siteUser.blank?)
        @userFirstName = @siteUser.FirstName
        @userLastName = @siteUser.LastName
        @userUserName = @siteUser.UserName
      end
      
      @adminLoginDetails = SiteUser.find_by_sql("SELECT distinct adminUser.id, adminLogin.LoginDateTime, adminLogin.LogOutDateTime
                  FROM site_users adminUser LEFT JOIN admin_login_report_histories adminLogin ON adminUser.id = adminLogin.UserID where adminLogin.UserID = '" + @userID + "'")
    end
  end

  def CustomerSearchReport
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_CustomerSearchReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @query = "select cust.id, cust.FirstName, cust.LastName, custadd.StreetAddress, custadd.City, custadd.State, custadd.ZipCode, custPhone.ContactNumber, COUNT(*) as count
                      from customer_addresses custadd join customer_searches cust on cust.AddressID = custadd.id
                      join customer_phones custPhone on cust.id = custPhone.CustomerSearchID join customer_search_logs custLogs on cust.id = custLogs.CustomerSearchID join subscribed_users sUser on custLogs.UserID = sUser.id where cust.id is not null"
      
      if(params[:hidFirstName] != nil)
        params[:txtFirstName] = params[:hidFirstName]
      end
      
      if(params[:hidLastName] != nil)
        params[:txtLastName] = params[:hidLastName]
      end
      
      if(params[:hidStreetAddress] != nil)
        params[:txtStreetAddress] = params[:hidStreetAddress]
      end
      
      if(params[:hidselectCity] != nil)
        params[:selectCity] = params[:hidselectCity]
      end
      
      if(params[:hidZipCode] != nil)
        params[:txtZipCode] = params[:hidZipCode]
      end
      
      if(params[:hidPhoneNumber] != nil)
        params[:txtPhoneNumber] = params[:hidPhoneNumber]
      end
      
      if(params[:hidUserFirstName] != nil)
        params[:txtUserFirstName] = params[:hidUserFirstName]
      end 
      
      if(params[:hidUserLastName] != nil)
        params[:txtUserLastName] = params[:hidUserLastName]
      end     

      if(params[:hidSetFilter] == nil)
        
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
            @queryAddress = "custadd.StreetAddress = '" + @streetAddress + "'"
            @query = @query + " and " + @queryAddress
          end
        end

        @queryCityState = ""
        if(params[:selectCity] != nil)
          @cityState = params[:selectCity].strip()
          if(@cityState != "")
            @citystateValSplit = @cityState.split(',')
            @queryCityState = "custadd.City = '" + @citystateValSplit.at(0).strip() + "' and custadd.State = '" + @citystateValSplit.at(1).strip() + "'"
            @query = @query + " and " + @queryCityState
          end
        end

        @queryZipCode = ""
        if(params[:txtZipCode] != nil)
          @zipCode = params[:txtZipCode].strip()
          if(@zipCode != "")
            @queryZipCode = "custadd.ZipCode = '" + @zipCode + "'"
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
        
        @queryUserFirstName = ""
        if(params[:txtUserFirstName] != nil)
          @userFirstName = params[:txtUserFirstName].strip()
          if(@userFirstName != "")
            @queryUserFirstName = "sUser.FirstName = '" + @userFirstName +"'"
            @query = @query + " and " + @queryUserFirstName
          end
        end

        @queryUserLastName = ""
        if(params[:txtUserLastName] != nil)
          @userLastName = params[:txtUserLastName].strip()
         if(@userLastName != "")
            @queryUserLastName = "sUser.LastName = '" + @userLastName +"'"
            @query = @query + " and " + @queryUserLastName
          end
        end

        if(!@query.blank?)
          @query = @query + " group by cust.id, cust.FirstName, cust.LastName, custadd.StreetAddress, custadd.City, custadd.State, custadd.ZipCode, custPhone.ContactNumber"
          @custSearchDetails = CustomerSearch.find_by_sql(@query)
        end
      else
        @custSearchDetails = CustomerSearch.find_by_sql("select cust.id, cust.FirstName, cust.LastName, custadd.StreetAddress, custadd.City, custadd.State, custadd.ZipCode, custPhone.ContactNumber, COUNT(*) as count
                      from customer_addresses custadd join customer_searches cust on cust.AddressID = custadd.id
                      join customer_phones custPhone on cust.id = custPhone.CustomerSearchID join customer_search_logs custLogs on cust.id = custLogs.CustomerSearchID
                      group by cust.id, cust.FirstName, cust.LastName, custadd.StreetAddress, custadd.City, custadd.State, custadd.ZipCode, custPhone.ContactNumber")
    
      end

    end
  end

  def ViewCustomerSearchBy
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_CustomerSearchReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @searchDetail = CustomerSearch.find_by_sql("select cust.FirstName, cust.LastName, custadd.*, custphone.ContactNumber
                      from customer_addresses custadd join customer_searches cust on cust.AddressID = custadd.id
                      join customer_phones custphone on cust.id = custphone.CustomerSearchID
                      where cust.id = '" + params[:hidCustID] + "'")

      @revfirstName = @searchDetail[0].FirstName
      @revlastName = @searchDetail[0].LastName
      @revstreetAddress = @searchDetail[0].StreetAddress
      @revcitystateVal = @searchDetail[0].City + ', ' + @searchDetail[0].State
      @revzipCode = @searchDetail[0].ZipCode
      @revphoneNumber = @searchDetail[0].ContactNumber

      @custReviewDetails = CustomerSearch.find_by_sql("SELECT distinct subUser.id, subUser.FirstName, subUser.LastName, custRev.IsReviewGiven, custRev.IsRequestSent, custRev.DateCreated, COUNT(*) as SearchCount
                  FROM customer_search_logs csLogs JOIN customer_review_joins custRev ON csLogs.UserID = custRev.UserID and csLogs.CustomerSearchID = custRev.CustomerSearchID join subscribed_users subUser ON subUser.id = custRev.UserID where csLogs.CustomerSearchID = '" + params[:hidCustID] + "' group by subUser.id, subUser.FirstName, subUser.LastName, custRev.IsReviewGiven, custRev.IsRequestSent, custRev.DateCreated")
    end
  end
  
  def AdminActivityReport
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminActivityReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @siteUser =  SiteUser.all
      @operation = OperationList.all
      
      @queryAdmin = ""
      @sUserID = '0'
      @opID = '0'
      
      if(params[:hidAdmin] != nil)
        params[:selectAdmin] = params[:hidAdmin]
      end
      if(params[:hidOperation] != nil)
        params[:selectOperation] = params[:hidOperation]
      end
      if(params[:hidFrom] != nil)
        params[:textDateFrom] = params[:hidFrom]
      end
      if(params[:hidTo] != nil)
        params[:textDateTo] = params[:hidTo]
      end 
      
      if(params[:selectAdmin] != nil)
          @sUserID = params[:selectAdmin]
          if(@sUserID == '0')
            @queryAdmin = ""
          else
            @queryAdmin =" and adminUser.id = '" + @sUserID + "'"
          end
        end
        
      if(params[:selectOperation] != nil)
          @opID = params[:selectOperation]
          if(@opID == '0')
            @queryOperation = ""
          else
            @queryOperation =" and adminAct.OPCode = '" + @opID + "'"
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
        @queryDate = " and adminAct.DateCreated BETWEEN '" + @dateFrom + "' AND '" + @dateTo + "'"
      elsif(@dateFrom != "" && @dateTo == "")
        @queryDate = " and adminAct.DateCreated >= '" + @dateFrom + "'"
      elsif(@dateFrom == "" && @dateTo != "")
        @queryDate = " and adminAct.DateCreated <= '" + @dateTo + "'"
      else
        @queryDate = ""
      end

      
      @query ="SELECT distinct adminUser.FirstName, adminUser.LastName, opList.Operation, adminAct.id, adminAct.OPCode, adminAct.TaskID, adminAct.DateCreated
                  FROM site_users adminUser JOIN admin_activities adminAct ON adminUser.id = adminAct.UserID JOIN operation_lists opList on adminAct.OPCode = opList.OPCode where adminUser.id is not null"
      
      if(!@queryAdmin.blank?)
        @query = @query + @queryAdmin
      end
      
      if(!@queryOperation.blank?)
        @query = @query + @queryOperation
      end
      
      if(!@queryDate.blank?)
        @query = @query + @queryDate
      end
      
      @adminActivity = AdminActivity.find_by_sql(@query)
    end
  end
  
  def ViewReview
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminActivityReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @operationID = params[:hidOPCode]
      @reportID = params[:hidReportID]
      @reviewAnswers = ReviewAnswerHistoryReport.find_by_sql("select * from review_answer_history_reports where ReportID= '" +  @reportID.to_s + "'")
      if(!@reviewAnswers.blank?)
      @reviewQuestion = ReviewQuestion.all
      @reviewDetails = CustomerSearch.find_by_sql("select cust.FirstName, cust.LastName, custadd.*, custphone.ContactNumber
                      from customer_addresses custadd join customer_searches cust on cust.AddressID = custadd.id
                      join customer_phones custphone on cust.id = custphone.CustomerSearchID
                      join reviews rev on cust.ID  = rev.CustomerSearchID
                      where rev.id = '" + @reviewAnswers[0].ReviewID.to_s + "'")

      @revfirstName = @reviewDetails[0].FirstName
      @revlastName = @reviewDetails[0].LastName
      @revstreetAddress = @reviewDetails[0].StreetAddress
      @revcitystateVal = @reviewDetails[0].City + ', ' + @reviewDetails[0].State
      @revzipCode = @reviewDetails[0].ZipCode
      @revphoneNumber = @reviewDetails[0].ContactNumber
      end        
    end
  end
  
  def ViewAdmin
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminActivityReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @operationID = params[:hidOPCode]
      @reportID = params[:hidReportID]

      @siteUser = SiteUserHistory.find_by(ReportID: @reportID)
      if(!@siteUser.blank?)
        @userFirstName = @siteUser.FirstName
        @userLastName = @siteUser.LastName
        @userEmail = @siteUser.EmailID
        @userUserName = @siteUser.UserName
        
        @siteModule = SiteModule.all
        @siteModuleUser = SiteModuleUserJoinHistory.find_by_sql("select * from site_module_user_join_histories where ReportID = '" + @reportID.to_s + "' and UserID = '" + @siteUser.UserID.to_s + "'")
      end
    end
  end
  
  def ViewUser
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminActivityReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @operationID = params[:hidOPCode]
      @reportID = params[:hidReportID]

      if(!@reportID.blank?)
        @subUser = SubscribedUserHistory.find_by(ReportID: @reportID)
        @subAddress1 = UserAddressDetailHistory.find_by(UserID: @subUser.UserID, ReportID: @reportID, AddressType: 'Business')
        @subAddress2 = UserAddressDetailHistory.find_by(UserID: @subUser.UserID, ReportID: @reportID, AddressType: 'Mailing')
        @subPrice = UserPaymentDetail.find_by(UserID: @subUser.UserID)
        @subAuthKey = Key.find_by(UserID: @subUser.UserID)
        if(!@subUser.blank? && !@subAddress1.blank? && !@subAddress2.blank?)
          @usercompanyName = @subUser.CompanyName
          @userfirstName = @subUser.FirstName
          @userlastName = @subUser.LastName
          @userincorporationType = @subUser.IncorporationType
          @userphoneNumber = @subUser.ContactNumber
          @useremail = @subUser.EmailID
          @userlicense = @subUser.LicenseNumber
          @userName = @subUser.UserName

          @userbussStreetAddress = @subAddress1.Address
          @userbusscitystateVal = @subAddress1.City + ', ' + @subAddress1.State
          @userbussZipCode = @subAddress1.ZipCode

          @usermailStreetAddress = @subAddress2.Address
          @usermailcitystateVal = @subAddress2.City + ', ' + @subAddress2.State
          @usermailZipCode = @subAddress2.ZipCode

          if(@userbussStreetAddress == @usermailStreetAddress && @userbusscitystateVal == @userbusscitystateVal && @userbussZipCode == @usermailZipCode)
            @addressCheck = true
          else
            @addressCheck = false
          end
        end
      end
    end
  end
  
  def ViewMLJudgements
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminActivityReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @operationID = params[:hidOPCode]
      @reportID = params[:hidReportID]
      
      @addressID = params[:hidAddressID]
      @mljudgement = MlJudgementHistory.find_by(ReportID: @reportID)
      @addresses =  CustomerAddress.find_by(id: @mljudgement.AddressID)
      

      if(!@addresses.blank?)
        @textStreetAddress = @addresses.StreetAddress
        @textCity = @addresses.City
        @textState = @addresses.State
        @textZipCode = @addresses.ZipCode
      end
      if(!@mljudgement.blank?)
        @textMLJudgements = @mljudgement.MLJudgements
      end
    end
  end
  
  def ViewCourtProceedings
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminActivityReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @operationID = params[:hidOPCode]
      @reportID = params[:hidReportID]
      
      

      @courtProceeding = CourtProceedingHistory.find_by(ReportID: @reportID)
      
      @addresses =  CustomerAddress.find_by(id: @courtProceeding.AddressID)
      if(!@addresses.blank?)
        @textStreetAddress = @addresses.StreetAddress
        @textCity = @addresses.City
        @textState = @addresses.State
        @textZipCode = @addresses.ZipCode
      end
      
      if(!@courtProceeding.blank?)
        @caseType = @courtProceeding.CaseType
        @hearingDate = @courtProceeding.CourtHearingDate.strftime('%m/%d/%Y')
        @caseFiledDate = @courtProceeding.DateFiled.strftime('%m/%d/%Y')
        @amountAwarded = @courtProceeding.AmountAwarded
        @defendant = DefendantsHistory.find_by(ReportID: @reportID, DefendantID: @courtProceeding.DefendantID)
        if(!@defendant.blank?)
          @defFirstName = @defendant.FirstName
          @defLastName = @defendant.LastName
          @defAddress = @defendant.StreetAddress
          @defCityState = @defendant.City + ", " + @defendant.State
          @defZipcode = @defendant.ZipCode
        end
        @plaintiff = PlaintiffsHistory.find_by(ReportID: @reportID, PlaintiffID: @courtProceeding.PlaintiffID)
        if(!@plaintiff.blank?)
          @plainFirstName = @plaintiff.FirstName
          @plainLastName = @plaintiff.LastName
          @plainAddress = @plaintiff.StreetAddress
          @plainCityState = @plaintiff.City + ", " + @plaintiff.State
          @plainZipcode = @plaintiff.ZipCode
        end
      end

      @lien = LiensHistory.find_by(ReportID: @reportID)
      if(!@lien.blank?)
        @dateIssued = @lien.DateIssued.strftime('%m/%d/%Y')
        @amount = @lien.Amount
        @grantor = GrantorsHistory.find_by(ReportID: @reportID, GrantorID: @lien.GrantorID)
        if(!@grantor.blank?)
          @grantFirstName = @grantor.FirstName
          @grantLastName = @grantor.LastName
          @grantAddress = @grantor.StreetAddress
          @grantCityState = @grantor.City + ", " + @grantor.State
          @grantZipcode = @grantor.ZipCode
        end
      end
    end
  end
  
  def ViewSiteContent
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminActivityReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @operationID = params[:hidOPCode]
      @reportID = params[:hidReportID]
      
      @siteContent = SiteContentHistory.find_by(ReportID: @reportID)
      @content = @siteContent.Content.html_safe
      @title = @siteContent.Title
    end
  end
  
  def ViewFAQ
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminActivityReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @operationID = params[:hidOPCode]
      @reportID = params[:hidReportID]
      
      @faq = FaqHistory.find_by(ReportID: @reportID)
      if(!@faq.blank?)
        @question = @faq.Question
        @answer = @faq.Answers
      end
    end
  end
  
  def ViewTestimonials
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminActivityReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @operationID = params[:hidOPCode]
      @reportID = params[:hidReportID]
      
      @testimonial = TestimonialHistory.find_by(ReportID: @reportID)
      if(!@testimonial.blank?)
        @firstName = @testimonial.FirstName
        @lastName = @testimonial.LastName
        @occupation = @testimonial.Occupation
        @comments = @testimonial.Comments
      end
    end
  end
  
  def ViewNewsUpdate
    @moduleID = SiteModule.find_by(Module: 'Reports')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminActivityReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @operationID = params[:hidOPCode]
      @reportID = params[:hidReportID]
      
      @newsUpdates = NewsUpdateHistory.find_by(ReportID: @reportID)
      if(!@newsUpdates.blank?)
        @comments = @newsUpdates.Comments
      end
    end
  end
  
end
