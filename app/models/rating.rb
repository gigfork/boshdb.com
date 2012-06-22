class Rating < ActiveRecord::Base
  attr_accessible :rating, :release_id, :user_id
  
  belongs_to :release
  belongs_to :user

end
