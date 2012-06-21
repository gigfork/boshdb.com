class Rating < ActiveRecord::Base
  attr_accessible :rating, :release_id, :user_id
end
