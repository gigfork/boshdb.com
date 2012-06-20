class CommentsController < ApplicationController
  
  def create
    # Extract the parameters
    release_id = params[:release][:id]
    comment_text = params[:comment][:comment]
        
    # Create the comment
    if user_signed_in?
      @release = Release.find_by_id(release_id)
      @comment = Comment.new
      @comment.release_id = @release.id
      @comment.user_id = current_user.id
      @comment.comment = comment_text
      @comment.save
    end
    
    redirect_to @release
  end
  
end