class ActivitiesController < ApplicationController
  before_action :require_login, only: %i[index read]
  
  def index
    @activities = current_user.activities.order(created_at: :desc)
  end

  def read
    activity = current_user.activities.find(params[:id])
    activity.read! if activity.unread?
    redirect_to activity.redirect_path
  end
end
