class ReleasesController < ApplicationController
  
  before_filter :authenticate_user!, :except => [:show, :index, :download, :user]
  
  # GET /releases
  # GET /releases.json
  def index
    @releases = Release.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @releases }
    end
  end

  # GET /releases/1
  # GET /releases/1.json
  def show
    @release = Release.find(params[:id])
    @total_downloads = 0
    @release.versions.each do |v|
      @total_downloads += v.downloads
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @release }
    end
  end

  # GET /releases/new
  # GET /releases/new.json
  def new
    @release = Release.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @release }
    end
  end

  # GET /releases/1/edit
  def edit
    @release = Release.find(params[:id])
    
    if current_user.id != @release.user.id
      respond_to do |format|
        format.html { redirect_to @release, notice: "You do not have permission to edit this release" }
        format.json { head :no_content }
      end
    end
  end

  # POST /releases
  # POST /releases.json
  def create
    # Extract the version info
    release = params[:release]
    version = params[:release][:version]
    release.delete("version")
    
    # Add http:// prefix to source_url if it doesn't already exist
    release[:source_url] = "http://#{release[:source_url]}" if not  release[:source_url].starts_with? "http://" and not release[:source_url].starts_with? "https://"
    
    @release = Release.new(release)
    @release.user = current_user
    
    # Add the version info
    # If the URL doesn't start with http:// or https://, add it
    version[:download_url] = "http://#{version[:download_url]}" if not  version[:download_url].starts_with? "http://" and not version[:download_url].starts_with? "https://"
    
    @version = Version.new(version)
    @version.version_number = 1
    @version.release = @release
    @release.versions << @version

    respond_to do |format|
      if @release.save
        format.html { redirect_to @release, notice: 'Release was successfully created.' }
        format.json { render json: @release, status: :created, location: @release }
      else
        format.html { render action: "new" }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /releases/1
  # PUT /releases/1.json
  def update
    @release = Release.find(params[:id])
    
    if current_user.id != @release.user.id
      respond_to do |format|
        format.html { redirect_to @release, notice: "You do not have permission to edit this release" }
        format.json { head :no_content }
      end
    end

    respond_to do |format|
      if @release.update_attributes(:description => params[:release][:description])
        format.html { redirect_to @release, notice: 'Release was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @release.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /releases/1
  # DELETE /releases/1.json
  def destroy
    @release = Release.find(params[:id])
    
    if current_user.id == @release.user.id
      @release.destroy
      respond_to do |format|
        format.html { redirect_to "/releases" }
        format.json { head :no_content }
      end
    else
      # Do not have permission to delete this release
      respond_to do |format|
        format.html { redirect_to @release, notice: 'You do not have permission to delete this release'}
        format.json { head :no_content }
      end
    end    
  end
  
  def user
    username = params[:username]    
    @user = User.find_by_username(username)
    @releases = @user.releases
    
    respond_to do |format|
      format.html # user.html.erb
      format.json { render json: @releases }
    end
  end
end
