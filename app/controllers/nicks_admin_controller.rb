class NicksAdminController < ApplicationController
    def Index
    @openLogin = ''
    if(!flash[:userName].blank? && !flash[:error].blank?)
      @openLogin = 1
      @userName = flash[:userName]
      @errorMessage = flash[:error]
    end
    
    if(!flash[:redirectUrl].blank?)
      @openLogin = 1
      @redirectUrl = flash[:redirectUrl]
    end   
  end
  
  def About
    
  end
  
  def HowItWorks
    
  end
end