class ProfilesController < ApplicationController

  load_and_authorize_resource through: :current_user, singleton: true
  layout 'non_landing'

  def show
  end

  def edit
    
  end

  def update
    
  end
end