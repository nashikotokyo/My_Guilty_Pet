class ActivitiesController < ApplicationController
  before_action :require_login, only: %i[index]
  
  def index
    @activities = current_user.activities.order(created_at: :desc)
  end
end
