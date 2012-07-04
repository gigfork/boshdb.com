class PagesController < ApplicationController
  def index
    @releases_top5 = Release.order("rating").limit(5)
    @releases_newest = Release.order("created_at DESC").limit(5)
  end
end