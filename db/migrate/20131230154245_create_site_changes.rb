class CreateSiteChanges < ActiveRecord::Migration
  def change
    change_table :site_users do |t|
      t.add :IsSuperAdmin, :boolean, :null => false
    end
    
    change_table :site_contents do |t|
      t.add :PageCode, :integer, :limit => 3, :null => false
    end
  end
end
