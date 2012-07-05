class PagesController < ApplicationController
  def index
    @releases_top5 = Release.order("rating").limit(5)
    @releases_newest = Release.order("created_at DESC").limit(5)
  end
  
  def search
    @result = []
    if params[:q]
      q = "%#{params[:q]}%"
      @results = Release.where("name like ? or description like ?", q, q)
    end
  end
end