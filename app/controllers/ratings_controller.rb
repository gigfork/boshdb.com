class RatingsController < ApplicationController
  
  before_filter :authenticate_user!
  
  def rate
    release_id = params[:release].to_f
    rating_val = params[:rating].to_f
    
    @release = Release.find_by_id(release_id)
    
    if user_signed_in?
      # User signed in, let's make sure that they havn't voted on this release yet
      existing_rating = nil
      @release.ratings.each do |rating|
        if rating.user.id == current_user.id
          existing_rating = rating
        end
      end
      
      if existing_rating
        # Has an existing rating, modify current vote
        existing_rating.rating = rating_val
        existing_rating.save
        @rating = existing_rating
      else
        # No existing rating, make a new one
        @rating = Rating.new
        @rating.release_id = release_id
        @rating.user_id = current_user.id
        @rating.rating = rating_val
        @rating.save
      end
      
      total_score = 0
      total_votes = 0
      ratings = Rating.find_all_by_release_id(@release.id)
      puts ratings.inspect
      if ratings.kind_of?(Array)
        ratings.each do |r|
         puts r.inspect
         total_score += r.rating
         total_votes += 1
        end
      else
        total_score = ratings.rating
        total_votes = 1
      end
    end
    
    @release.rating = (total_score.to_f / total_votes.to_f).round(2)
    @release.save
    
    redirect_to @release
    
  end
  
end