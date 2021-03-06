class CreateCourtProceedingHistories < ActiveRecord::Migration
  def change
    create_table :court_proceeding_histories do |t|
      t.column :ReportID, :integer, :limit => 11, :null => false
      t.column :AddressID, :integer, :limit => 11, :null => false
      t.column :PlaintiffID, :integer, :limit => 11, :null => false
      t.column :DefendantID, :integer, :limit => 11, :null => false
      t.column :CaseType, :string, :limit => 30, :null => false
      t.column :CourtHearingDate, :datetime, :null => false
      t.column :DateFiled, :datetime, :null => false
      t.column :AmountAwarded, :float, :null => false
      t.column :DateCreated, :datetime, :null => false
      t.column :DateUpdated, :datetime, :null => false
    end
    
    # add a foreign key
    execute <<-SQL
    ALTER TABLE court_proceeding_histories
      ADD CONSTRAINT fk_court_proceeding_histories_ReportID
      FOREIGN KEY (ReportID)
      REFERENCES admin_activities(id)
    SQL
    
    # add a foreign key
    execute <<-SQL
    ALTER TABLE court_proceeding_histories
      ADD CONSTRAINT fk_court_proceeding_histories_AddressID
      FOREIGN KEY (AddressID)
      REFERENCES customer_addresses(id)
    SQL
    
    # add a foreign key
    execute <<-SQL
    ALTER TABLE court_proceeding_histories
      ADD CONSTRAINT fk_court_proceeding_histories_PlaintiffID
      FOREIGN KEY (PlaintiffID)
      REFERENCES plaintiffs(id)
    SQL
    
    # add a foreign key
    execute <<-SQL
    ALTER TABLE court_proceeding_histories
      ADD CONSTRAINT fk_court_proceeding_histories_DefendantID
      FOREIGN KEY (DefendantID)
      REFERENCES defendants(id)
    SQL
  end
end