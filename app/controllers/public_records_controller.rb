class PublicRecordsController < ApplicationController
  skip_before_action :verify_authenticity_token
  def ManagePublicRecords
    @moduleID = SiteModule.find_by(Module: 'Public Records')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => public_records_ManagePublicRecords_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end

    @addresses =  CustomerAddress.all

  end

  def EditMLJudgements
    @moduleID = SiteModule.find_by(Module: 'Public Records')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => public_records_ManagePublicRecords_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
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

  def UpdateMLJudgements
    @moduleID = SiteModule.find_by(Module: 'Public Records')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => public_records_ManagePublicRecords_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end
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
    redirect_to public_records_ManagePublicRecords_url, :notice => "ML&Judgement details updated successfuly!"
  end

  def EditCourtProceedings
    @moduleID = SiteModule.find_by(Module: 'Public Records')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => public_records_ManagePublicRecords_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end

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

  def UpdateCourtProceedings
    @moduleID = SiteModule.find_by(Module: 'Public Records')
    @authCount = SiteModuleUserJoin.where(ModuleID: @moduleID.id, UserID: session[:user_id]).count

    if(!session[:user_id])
      redirect_to nicks_admin_Index_url, flash:{:redirectUrl => public_records_ManagePublicRecords_url}
    elsif(@authCount.to_i == 0)
      redirect_to nicks_admin_Index_url
    end

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
    
    @courtProceeding = CourtProceedings.find_by(AddressID: @addressID)
    if(!@courtProceeding.blank?)
      @courtProceeding.CaseType = params[:textCaseType]
      @courtProceeding.CourtHearingDate = Date.strptime(params[:textHearingDate], "%m/%d/%Y")
      @courtProceeding.DateFiled = Date.strptime(params[:textCaseFiledDate], "%m/%d/%Y")
      @courtProceeding.AmountAwarded = params[:textAmountAwarded]
      @courtProceeding.DateUpdated = time
      @courtProceeding.save 
      
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
      end
    else
      @defendant = Defendants.find_by(FirstName: params[:textDefFirstName], LastName: params[:textDefLastName], StreetAddress: params[:textDefAddress], City: @defCity, State: @defState, ZipCode: params[:textDefZipCode])
      if(@defendant.blank?)
        @defendant = Defendants.new(FirstName: params[:textDefFirstName], LastName: params[:textDefLastName], StreetAddress: params[:textDefAddress], City: @defCity, State: @defState, ZipCode: params[:textDefZipCode], DateCreated: time, DateUpdated: time)
        @defendant.save
      end
      @plaintiff = Plaintiffs.find_by(FirstName: params[:textPlainFirstName], LastName: params[:textPlainLastName], StreetAddress: params[:textPlainAddress], City: @plainCity, State: @plainState, ZipCode: params[:textPlainZipCode])
      if(@plaintiff.blank?)
        @plaintiff = Plaintiffs.new(FirstName: params[:textPlainFirstName], LastName: params[:textPlainLastName], StreetAddress: params[:textPlainAddress], City: @plainCity, State: @plainState, ZipCode: params[:textPlainZipCode], DateCreated: time, DateUpdated: time)
        @plaintiff.save
      end
      @courtProceeding = CourtProceedings.new(AddressID: @addressID, PlaintiffID: @plaintiff.id, DefendantID: @defendant.id, CaseType: params[:textCaseType], CourtHearingDate: params[:textHearingDate], DateFiled: params[:textCaseFiledDate], AmountAwarded: params[:textAmountAwarded], DateCreated: time, DateUpdated: time)
      @courtProceeding.save
    end

    @lien = Liens.find_by(AddressID: @addressID)
    if(!@lien.blank?)
      @lien.DateIssued = Date.strptime(params[:textDateIssued], "%m/%d/%Y")
      @lien.Amount = params[:textAmount]
      @lien.DateUpdated = time 
      @lien.save
      
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
      end
    else
      @grantor = Grantors.find_by(FirstName: params[:textGrantFirstName], LastName: params[:textGrantLastName], StreetAddress: params[:textGrantAddress], City: @grantCity, State: @grantState, ZipCode: params[:textGrantZipCode])
      if(@grantor.blank?)
        @grantor = Grantors.new(FirstName: params[:textGrantFirstName], LastName: params[:textGrantLastName], StreetAddress: params[:textGrantAddress], City: @grantCity, State: @grantState, ZipCode: params[:textGrantZipCode], DateCreated: time, DateUpdated: time)
        @grantor.save
      end
      @lien = Liens.new(AddressID: @addressID, GrantorID: @grantor.id, DateIssued: params[:textDateIssued], Amount: params[:textAmount], DateCreated: time, DateUpdated: time)
      @lien.save
    end
    redirect_to public_records_ManagePublicRecords_url, :notice => "Court Proceeding details updated successfuly!"
  end
end
