class ProfilesController < ApplicationController
  before_action :set_user, only: %i[edit update]

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to profile_path, success: t("defaults.flash_message.user_update")
    else
      flash.now[:danger] = t("defaults.flash_message.user_not_update")
      render :edit, status: :unprocessable_entity
    end
  end

  def show; end

  private

  def set_user
    @user = User.find(current_user.id)
  end

  def user_params
    params.require(:user).permit(:email, :name, :avatar)
  end
end
