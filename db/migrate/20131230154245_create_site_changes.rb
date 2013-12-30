class CreateSiteChanges < ActiveRecord::Migration
  def change
    add_column :site_users, :IsSuperAdmin, :boolean, :null => false
    add_column :site_contents, :PageCode, :integer, :limit => 3, :null => false
  end
end
