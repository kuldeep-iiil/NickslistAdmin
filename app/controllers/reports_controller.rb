class ReportsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def UserLoginReport
    @authCount = SiteUser.where(id: session[:user_id], IsSuperAdmin: 1).count
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
    @authCount = SiteUser.where(id: session[:user_id], IsSuperAdmin: 1).count
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
    @authCount = SiteUser.where(id: session[:user_id], IsSuperAdmin: 1).count
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_UserLoginReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @userLoginDetails = SubscribedUser.find_by_sql("SELECT distinct subUser.id, userLogin.LoginDateTime, userLogin.LogOutDateTime
                  FROM subscribed_users subUser LEFT JOIN user_login_report_histories userLogin ON subUser.id = userLogin.UserID where userLogin.UserID = '" + params[:hidUserID] + "'")
    end
  end

  def ViewAdminLoginHistory
    @authCount = SiteUser.where(id: session[:user_id], IsSuperAdmin: 1).count
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_AdminLoginReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @adminLoginDetails = SiteUser.find_by_sql("SELECT distinct adminUser.id, adminLogin.LoginDateTime, adminLogin.LogOutDateTime
                  FROM site_users adminUser LEFT JOIN admin_login_report_histories adminLogin ON adminUser.id = adminLogin.UserID where adminLogin.UserID = '" + params[:hidUserID] + "'")
    end
  end

  def CustomerSearchReport
    @authCount = SiteUser.where(id: session[:user_id], IsSuperAdmin: 1).count
    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => reports_CustomerSearchReport_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @custSearchDetails = CustomerSearch.find_by_sql("select cust.id, cust.FirstName, cust.LastName, custadd.StreetAddress, custadd.City, custadd.State, custadd.ZipCode, custPhone.ContactNumber, COUNT(*) as count
                      from customer_addresses custadd join customer_searches cust on cust.AddressID = custadd.id
                      join customer_phones custPhone on cust.id = custPhone.CustomerSearchID join customer_search_logs custLogs on cust.id = custLogs.CustomerSearchID
                      group by cust.id, cust.FirstName, cust.LastName, custadd.StreetAddress, custadd.City, custadd.State, custadd.ZipCode, custPhone.ContactNumber")
    end
  end

  def ViewCustomerSearchBy
    @authCount = SiteUser.where(id: session[:user_id], IsSuperAdmin: 1).count
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

      @custReviewDetails = CustomerSearch.find_by_sql("SELECT distinct subUser.id, subUser.FirstName, subUser.LastName, custRev.IsReviewGiven, custRev.IsRequestSent, custRev.DateCreated
                  FROM subscribed_users subUser JOIN customer_review_joins custRev ON subUser.id = custRev.UserID where custRev.CustomerSearchID = '" + params[:hidCustID] + "'")
    end
  end
end
