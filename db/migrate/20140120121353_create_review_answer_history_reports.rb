class CreateReviewAnswerHistoryReports < ActiveRecord::Migration
  def change
    create_table :review_answer_history_reports do |t|
      t.column :ReportID, :integer, :limit => 11, :null => false
      t.column :ReviewID, :integer, :limit => 11, :null => false
      t.column :QuestionID, :integer, :limit => 11, :null => false
      t.column :Comments, :text
      t.column :IsYes, :string, :limit => 50
      t.column :DateCreated, :datetime, :null => false
      t.column :DateUpdated, :datetime, :null => false
    end
  end
end
