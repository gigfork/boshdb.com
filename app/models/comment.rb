class Comment < ActiveRecord::Base
  attr_accessible :comment, :release_id, :user_id
  
  belongs_to :release
  belongs_to :user
end
