require 'URI'

class VersionsController < ApplicationController

  before_filter :authenticate_user!, :except => [:download]
  
  def download
    release_id = params[:release_id]
    version_number = params[:version_number]
    
    @version = Version.where('version_number = ? AND release_id = ?', version_number, release_id).first
    
    # Test to make sure that the download URL is valid
    valid_url = false
    download_url = ""
    begin
      url = URI.parse(@version.download_url)
      if url.scheme != nil and url.host != nil
        valid_url = true
        download_url = @version.download_url
      end
    rescue
    end
    
    # If it's not a valid URL, let's see if it's a GitHub source URL, and work from there
    if !valid_url
      begin
        url = URI.parse(@version.release.source_url)
        if url.host.downcase == "github.com"
          github_url = @version.release.source_url
          if !github_url.ends_with?("/")
            github_url += "/"
          end
          github_url += "tarball/master"
          valid_url = true
          download_url = github_url
        end
      rescue
      end
    end
    
    if valid_url
      # We found a valid download URL
      # Increase the download count
      @version.downloads += 1
      @version.save
    
      redirect_to download_url
    else
      # No valid download URL could be determined, throw and error and redirect
      respond_to do |format|
        format.html { redirect_to @version.release, notice: "There was an error downloading the selected release" }
        format.json { head :no_content }
      end
    end
  end
  
  # POST /versions
  def create
    # Extract the parameters
    download_url = params[:version][:download_url]
    release_id = params[:release][:id]
    @release = Release.find_by_id(release_id)
    version_number = @release.versions.last.version_number + 1
    
    # Clean up the data
    download_url = "http://#{download_url}" if not download_url.starts_with? "http://" and not download_url.starts_with? "https://"
    
    # Make sure that the currently logged in user is the one adding the version
    if user_signed_in? && current_user.id == @release.user.id
      @version = Version.new
      @version.release_id = release_id
      @version.version_number = version_number
      @version.download_url = download_url
      @version.downloads = 0
      @version.save
    end
    
    redirect_to @release
  end
end
