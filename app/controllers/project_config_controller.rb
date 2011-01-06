class ProjectConfigController < ApplicationController
  before_filter :find_user
  
  # Returns the collection of configured projects for current user
  def index
    find_configurations
  end
  
  # Searches for all the projects registered under the key
  # Fails under the following conditions:
  # * No api_key present in the parameters
  # * api_key is present but empty
  # * Listing the projects raises an exception
  # In those cases the flash[:error] is set with a message
  def create
    @error = params[:api_key].nil? || params[:api_key].empty?
    begin
      if !@error
        find_projects(params[:api_key])
      else
        flash[:error] = 'Sorry, you need an api-key in order to search for projects'
      end
    rescue Exception => ex
      @error = true
      logger.error ex
      logger.error ex.backtrace.join("\n")
      flash[:error] = 'Can\'t retrieve project information, make sure the key is valid'
    end  
    find_configurations    
  end
  
  # Creates a new configuration
  def new
    flash[:notice] = 'The new project configuration has been added'
    @current_config = ProjectConfig.create!(params["project"].merge!(:user => @user))
    find_projects(params['project']['api_key'])
    find_configurations    
  end
  
  # Deletes the configuration indicated by the id
  def destroy
    project = ProjectConfig.find(params[:id])
    project.destroy
    find_configurations    
  end
  
  private 
    # Finds the user that matches the user_id in the parameters
    def find_user
      @user = User.find(params[:user_id])
    end

    def find_projects(api_key)
      @api_key = Project.api_key = api_key
      @projects = Project.all
    end

    # Calculate the user configuration and a hash by key
    def find_configurations
      @configurations = @user.configurations
      @config_by_key = @configurations.inject({}) do |map, cfg|
        values = map[cfg.api_key] || []
        values << cfg
        map[cfg.api_key] = values
        map
      end
    end
end
