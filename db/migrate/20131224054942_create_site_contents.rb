class CreateSiteContents < ActiveRecord::Migration
  def change
    create_table :site_contents do |t|
      t.column :PageCode, :integer, :limit => 3, :null => false
      t.column :Title, :string, :limit => 20, :null => false
      t.column :Content, :text, :null =>false
      t.column :IsEnabled, :boolean, :null => false
      t.column :DateCreated, :datetime, :null => false
      t.column :DateUpdated, :datetime, :null => false
    end
    
    change_table :site_contents do |t|
      t.add :PageCode, :integer, :limit => 3, :null => false
    end
  end
end
