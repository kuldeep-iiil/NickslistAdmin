namespace :myrailsapp do
  desc "Review request will send to the users if they left searched cutomer without giving review."
  task review_request: :environment do
    puts "Checking and sending Review Request Mail..."
    e = ReviewRequest.new
    e.SendReviewRequest
  end
end