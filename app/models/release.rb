class Release < ActiveRecord::Base
  attr_accessible :description, :name, :source_url, :user_id, :release, :downloads
  
  belongs_to :user
  has_many :versions
  has_many :comments
  has_many :ratings
end
