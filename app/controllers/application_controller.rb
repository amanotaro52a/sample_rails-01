class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  add_flash_types :success, :danger
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :convert_devise_flash_messages

  private

  def convert_devise_flash_messages
    if flash[:notice]
      flash[:success] = flash[:notice]
      flash.delete(:notice)
    end

    if flash[:alert]
      flash[:danger] = flash[:alert]
      flash.delete(:alert)
    end
  end    
end
