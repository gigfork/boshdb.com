class RatingsController < ApplicationController
  
  def rate
    release_id = params[:release]
    rating_val = params[:rating]
    
    if user_signed_in?
      # User signed in, let's make sure that they havn't voted on this release yet
      @release = Release.find_by_id(release_id)
      existing_rating = nil
      @release.ratings.each do |rating|
        if rating.user.id == current_user.id
          existing_rating = rating
        end
      end
      
      if existing_rating
        # Has an existing rating, modify current vote
        @release.rating -= existing_rating.rating
        existing_rating.rating = rating_val
        existing_rating.save
        @rating = existing_rating
        @release.rating += @rating.rating
        @release.save
      else
        # No existing rating, make a new one
        @rating = Rating.new
        @rating.release_id = release_id
        @rating.user_id = current_user.id
        @rating.rating = rating_val
        @rating.save
        @release.rating += @rating.rating
        @release.save
      end
      
    end
    
    redirect_to @release
    
  end
  
end