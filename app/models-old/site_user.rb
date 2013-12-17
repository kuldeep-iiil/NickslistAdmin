class SiteUser < ActiveRecord::Base
  self.table_name = 'SiteUsers'
  self.primary_key = :ID
end
