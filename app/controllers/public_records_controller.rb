class PublicRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def ManagePublicRecords
    @moduleID = SiteModule.find_by(Module: 'Public Records')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => public_records_ManagePublicRecords_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

     @query = "SELECT * from customer_addresses where id is not null"

      if(params[:hidSetFilter] == nil)
        @queryAddress = ""
        if(params[:txtStreetAddress] != nil)
          @streetAddress = params[:txtStreetAddress].strip()
          if(@streetAddress != "")
            @queryAddress = "StreetAddress = '" + @streetAddress + "'"
            @query = @query + " and " + @queryAddress
          end
        end

        @queryCityState = ""
        if(params[:selectCity] != nil)
          @cityState = params[:selectCity].strip()
          if(@cityState != "")
            @citystateValSplit = @cityState.split(',')
            @queryCityState = "City = '" + @citystateValSplit.at(0).strip() + "' and custAdd.State = '" + @citystateValSplit.at(1).strip() + "'"
            @query = @query + " and " + @queryCityState
          end
        end

        @queryZipCode = ""
        if(params[:txtZipCode] != nil)
          @zipCode = params[:txtZipCode].strip()
          if(@zipCode != "")
            @queryZipCode = "ZipCode = '" + @zipCode + "'"
            @query = @query + " and " + @queryZipCode
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
          @queryDate = "DateCreated BETWEEN '" + @dateFrom + "' AND '" + @dateTo + "'"
        elsif(@dateFrom != "" && @dateTo == "")
          @queryDate = "DateCreated >= '" + @dateFrom + "'"
        elsif(@dateFrom == "" && @dateTo != "")
          @queryDate = "DateCreated <= '" + @dateTo + "'"
        else
          @queryDate = ""
        end

        if(!@queryDate.blank?)
          @query = @query + " and " + @queryDate
        end

        if(!@query.blank?)
          @addresses = CustomerAddress.find_by_sql(@query)
        end
      else
        @addresses =  CustomerAddress.all
      end
      
    end
  end

  def EditMLJudgements
    @moduleID = SiteModule.find_by(Module: 'Public Records')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => public_records_ManagePublicRecords_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      @addressID = params[:hidAddressID]
      @addresses =  CustomerAddress.find_by(id: @addressID)
      @mljudgement = MlJudgements.find_by(AddressID: @addressID)

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

  def UpdateMLJudgements
    @moduleID = SiteModule.find_by(Module: 'Public Records')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => public_records_ManagePublicRecords_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      
      @addressID = params[:hidAddressID]
      @mljudgement = MlJudgements.find_by(AddressID: @addressID)
      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      if(!@mljudgement.blank?)
        @mljudgement.MLJudgements = params[:textMLJudgements]
        @mljudgement.DateUpdated = time
        @mljudgement.save
      else
        @mljudgement = MlJudgements.new(AddressID: params[:hidAddressID], MLJudgements: params[:textMLJudgements], DateCreated: time, DateUpdated: time)
        @mljudgement.save
      end
      
      @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '114', TaskID: @mljudgement.id, DateCreated: time)
      @adminActivity.save
      
      @mljudgement = MlJudgementHistory.new(ReportID: @adminActivity.id, AddressID: params[:hidAddressID], MLJudgements: params[:textMLJudgements], DateCreated: time, DateUpdated: time)
      @mljudgement.save
      
      redirect_to public_records_ManagePublicRecords_url, :notice => "ML&Judgement details updated successfuly!"
    end
  end

  def EditCourtProceedings
    @moduleID = SiteModule.find_by(Module: 'Public Records')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => public_records_ManagePublicRecords_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else

      @addressID = params[:hidAddressID]
      @addresses =  CustomerAddress.find_by(id: @addressID)
      if(!@addresses.blank?)
        @textStreetAddress = @addresses.StreetAddress
        @textCity = @addresses.City
        @textState = @addresses.State
        @textZipCode = @addresses.ZipCode
      end

      @courtProceeding = CourtProceedings.find_by(AddressID: @addressID)
      if(!@courtProceeding.blank?)
        @caseType = @courtProceeding.CaseType
        @hearingDate = @courtProceeding.CourtHearingDate.strftime('%m/%d/%Y')
        @caseFiledDate = @courtProceeding.DateFiled.strftime('%m/%d/%Y')
        @amountAwarded = @courtProceeding.AmountAwarded
        @defendant = Defendants.find_by(id: @courtProceeding.DefendantID)
        if(!@defendant.blank?)
          @defFirstName = @defendant.FirstName
          @defLastName = @defendant.LastName
          @defAddress = @defendant.StreetAddress
          @defCityState = @defendant.City + ", " + @defendant.State
          @defZipcode = @defendant.ZipCode
        end
        @plaintiff = Plaintiffs.find_by(id: @courtProceeding.PlaintiffID)
        if(!@plaintiff.blank?)
          @plainFirstName = @plaintiff.FirstName
          @plainLastName = @plaintiff.LastName
          @plainAddress = @plaintiff.StreetAddress
          @plainCityState = @plaintiff.City + ", " + @plaintiff.State
          @plainZipcode = @plaintiff.ZipCode
        end
      end

      @lien = Liens.find_by(AddressID: @addressID)
      if(!@lien.blank?)
        @dateIssued = @lien.DateIssued.strftime('%m/%d/%Y')
        @amount = @lien.Amount
        @grantor = Grantors.find_by(id: @lien.GrantorID)
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

  def UpdateCourtProceedings
    @moduleID = SiteModule.find_by(Module: 'Public Records')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => public_records_ManagePublicRecords_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    else
      currentUserID = session[:user_id]

      @addressID = params[:hidAddressID]

      @defCityState = params[:textDefCity]
      @defCity = ""
      @defState = ""
      if(!@defCityState.blank?)
        @defCityState = @defCityState.split(',')
        @defCity = @defCityState.at(0).strip()
        @defState = @defCityState.at(1).strip()
      end

      @grantCityState = params[:textGrantCity]
      @grantCity = ""
      @grantState = ""
      if(!@grantCityState.blank?)
        @grantCityState = @grantCityState.split(',')
        @grantCity = @grantCityState.at(0).strip()
        @grantState = @grantCityState.at(1).strip()
      end

      @plainCityState = params[:textPlainCity]
      @plainCity = ""
      @plainState = ""
      if(!@plainCityState.blank?)
        @plainCityState = @plainCityState.split(',')
        @plainCity = @plainCityState.at(0).strip()
        @plainState = @plainCityState.at(1).strip()
      end

      currentTime = Time.new
      time = currentTime.strftime("%Y-%m-%d %H:%M:%S")
      
      @adminActivity = AdminActivity.new(UserID: currentUserID, OPCode: '115', TaskID: '0', DateCreated: time)
      @adminActivity.save

      @courtProceeding = CourtProceedings.find_by(AddressID: @addressID)
      if(!@courtProceeding.blank?)
        @courtProceeding.CaseType = params[:textCaseType]
        @courtProceeding.CourtHearingDate = Date.strptime(params[:textHearingDate], "%m/%d/%Y")
        @courtProceeding.DateFiled = Date.strptime(params[:textCaseFiledDate], "%m/%d/%Y")
        @courtProceeding.AmountAwarded = params[:textAmountAwarded]
        @courtProceeding.DateUpdated = time
        @courtProceeding.save
        
        @courtProceedingHistory = CourtProceedingHistory.new(ReportID: @adminActivity.id, AddressID: @courtProceeding.AddressID, PlaintiffID: @courtProceeding.PlaintiffID, DefendantID: @courtProceeding.DefendantID, CaseType: @courtProceeding.CaseType, CourtHearingDate: @courtProceeding.CourtHearingDate, DateFiled: @courtProceeding.DateFiled, AmountAwarded: @courtProceeding.AmountAwarded, DateCreated: time, DateUpdated: time)
        @courtProceedingHistory.save

        @defendant = Defendants.find_by(id: @courtProceeding.DefendantID)
        if(!@defendant.blank?)
          @defendant.FirstName = params[:textDefFirstName]
          @defendant.LastName = params[:textDefLastName]
          @defendant.StreetAddress = params[:textDefAddress]
          @defendant.City = @defCity
          @defendant.State = @defState
          @defendant.ZipCode = params[:textDefZipCode]
          @defendant.DateUpdated = time
          @defendant.save
          
          @defendantHistory = DefendantsHistory.new(ReportID: @adminActivity.id, DefendantID: @defendant.id, FirstName: @defendant.FirstName, LastName: @defendant.LastName, StreetAddress: @defendant.StreetAddress, City: @defendant.City, State: @defendant.State, ZipCode: @defendant.ZipCode, DateCreated: time, DateUpdated: time)
          @defendantHistory.save
        end

        @plaintiff = Plaintiffs.find_by(id: @courtProceeding.PlaintiffID)
        if(!@plaintiff.blank?)
          @plaintiff.FirstName = params[:textPlainFirstName]
          @plaintiff.LastName = params[:textPlainLastName]
          @plaintiff.StreetAddress = params[:textPlainAddress]
          @plaintiff.City = @plainCity
          @plaintiff.State = @plainState
          @plaintiff.ZipCode = params[:textPlainZipCode]
          @plaintiff.DateUpdated = time
          @plaintiff.save
          
          @plaintiffHistory = PlaintiffsHistory.new(ReportID: @adminActivity.id, PlaintiffID: @plaintiff.id, FirstName: @plaintiff.FirstName, LastName: @plaintiff.LastName, StreetAddress: @plaintiff.StreetAddress, City: @plaintiff.City, State: @plaintiff.State, ZipCode: @plaintiff.ZipCode, DateCreated: time, DateUpdated: time)
          @plaintiffHistory.save
        end
      else
        
        @defendant = Defendants.find_by(FirstName: params[:textDefFirstName], LastName: params[:textDefLastName], StreetAddress: params[:textDefAddress], City: @defCity, State: @defState, ZipCode: params[:textDefZipCode])
        if(@defendant.blank?)
          @defendant = Defendants.new(FirstName: params[:textDefFirstName], LastName: params[:textDefLastName], StreetAddress: params[:textDefAddress], City: @defCity, State: @defState, ZipCode: params[:textDefZipCode], DateCreated: time, DateUpdated: time)
          @defendant.save
          
          @defendantHistory = DefendantsHistory.new(ReportID: @adminActivity.id, DefendantID: @defendant.id, FirstName: @defendant.FirstName, LastName: @defendant.LastName, StreetAddress: @defendant.StreetAddress, City: @defendant.City, State: @defendant.State, ZipCode: @defendant.ZipCode, DateCreated: time, DateUpdated: time)
          @defendantHistory.save
        end
        @plaintiff = Plaintiffs.find_by(FirstName: params[:textPlainFirstName], LastName: params[:textPlainLastName], StreetAddress: params[:textPlainAddress], City: @plainCity, State: @plainState, ZipCode: params[:textPlainZipCode])
        if(@plaintiff.blank?)
          @plaintiff = Plaintiffs.new(FirstName: params[:textPlainFirstName], LastName: params[:textPlainLastName], StreetAddress: params[:textPlainAddress], City: @plainCity, State: @plainState, ZipCode: params[:textPlainZipCode], DateCreated: time, DateUpdated: time)
          @plaintiff.save
          
          @plaintiffHistory = PlaintiffsHistory.new(ReportID: @adminActivity.id, PlaintiffID: @plaintiff.id, FirstName: @plaintiff.FirstName, LastName: @plaintiff.LastName, StreetAddress: @plaintiff.StreetAddress, City: @plaintiff.City, State: @plaintiff.State, ZipCode: @plaintiff.ZipCode, DateCreated: time, DateUpdated: time)
          @plaintiffHistory.save
        end
        @courtProceeding = CourtProceedings.new(AddressID: @addressID, PlaintiffID: @plaintiff.id, DefendantID: @defendant.id, CaseType: params[:textCaseType], CourtHearingDate: Date.strptime(params[:textHearingDate], "%m/%d/%Y"), DateFiled: Date.strptime(params[:textCaseFiledDate], "%m/%d/%Y"), AmountAwarded: params[:textAmountAwarded], DateCreated: time, DateUpdated: time)
        @courtProceeding.save
        
        @courtProceedingHistory = CourtProceedingHistory.new(ReportID: @adminActivity.id, AddressID: @courtProceeding.AddressID, PlaintiffID: @courtProceeding.PlaintiffID, DefendantID: @courtProceeding.DefendantID, CaseType: @courtProceeding.CaseType, CourtHearingDate: @courtProceeding.CourtHearingDate, DateFiled: @courtProceeding.DateFiled, AmountAwarded: @courtProceeding.AmountAwarded, DateCreated: time, DateUpdated: time)
        @courtProceedingHistory.save
      end

      @lien = Liens.find_by(AddressID: @addressID)
      if(!@lien.blank?)
        @lien.DateIssued = Date.strptime(params[:textDateIssued], "%m/%d/%Y")
        @lien.Amount = params[:textAmount]
        @lien.DateUpdated = time
        @lien.save
        
        @lienHistory = LiensHistory.new(ReportID: @adminActivity.id, AddressID: @lien.AddressID, GrantorID: @lien.GrantorID, DateIssued: @lien.DateIssued, Amount: @lien.Amount, DateCreated: time, DateUpdated: time)
        @lienHistory.save

        @grantor = Grantors.find_by(id: @lien.GrantorID)
        if(!@grantor.blank?)
          @grantor.FirstName = params[:textGrantFirstName]
          @grantor.LastName = params[:textGrantLastName]
          @grantor.StreetAddress = params[:textGrantAddress]
          @grantor.City = @grantCity
          @grantor.State = @grantState
          @grantor.ZipCode = params[:textGrantZipCode]
          @grantor.DateUpdated = time
          @grantor.save
          
          @grantorHistory = GrantorsHistory.new(ReportID: @adminActivity.id, GrantorID: @grantor.id, FirstName: @grantor.FirstName, LastName: @grantor.LastName, StreetAddress: @grantor.StreetAddress, City: @grantor.City, State: @grantor.State, ZipCode: @grantor.ZipCode, DateCreated: time, DateUpdated: time)
          @grantorHistory.save
        end
      else
        @grantor = Grantors.find_by(FirstName: params[:textGrantFirstName], LastName: params[:textGrantLastName], StreetAddress: params[:textGrantAddress], City: @grantCity, State: @grantState, ZipCode: params[:textGrantZipCode])
        if(@grantor.blank?)
          @grantor = Grantors.new(FirstName: params[:textGrantFirstName], LastName: params[:textGrantLastName], StreetAddress: params[:textGrantAddress], City: @grantCity, State: @grantState, ZipCode: params[:textGrantZipCode], DateCreated: time, DateUpdated: time)
          @grantor.save
        
          @grantorHistory = GrantorsHistory.new(ReportID: @adminActivity.id, GrantorID: @grantor.id, FirstName: @grantor.FirstName, LastName: @grantor.LastName, StreetAddress: @grantor.StreetAddress, City: @grantor.City, State: @grantor.State, ZipCode: @grantor.ZipCode, DateCreated: time, DateUpdated: time)
          @grantorHistory.save
        end
        @lien = Liens.new(AddressID: @addressID, GrantorID: @grantor.id, DateIssued: Date.strptime(params[:textDateIssued], "%m/%d/%Y"), Amount: params[:textAmount], DateCreated: time, DateUpdated: time)
        @lien.save
        
        @lienHistory = LiensHistory.new(ReportID: @adminActivity.id, AddressID: @lien.AddressID, GrantorID: @lien.GrantorID, DateIssued: @lien.DateIssued, Amount: @lien.Amount, DateCreated: time, DateUpdated: time)
        @lienHistory.save
      end
      
      redirect_to public_records_ManagePublicRecords_url, :notice => "Court Proceeding details updated successfuly!"
    end
  end
end
