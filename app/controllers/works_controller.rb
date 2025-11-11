class WorksController < ApplicationController
  before_action :authenticate_user!

  def index
    @works = Work.includes(:user)
  end
end
