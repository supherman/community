class ApplicationController < ActionController::Base

def crowdblog_current_user
  current_identity
end

def crowdblog_authenticate_user!
  crowdblog_authenticate?
end

helper_method :crowdblog_current_user, :crowdblog_authenticate_user!

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  prepend_view_path "app/views/#{Rails.application.config.theme}"

  protect_from_forgery with: :exception

  helper_method :current_identity, :identity_signed_in?, :warden

  protected
  def warden
    request.env['warden']
  end

  def identity_signed_in?
    warden.authenticate?(scope: :identity)
  end

  def current_identity
    warden.user(scope: :identity)
  end

  def authenticate!
    redirect_to root_path, notice: t('.not_logged') unless identity_signed_in?
  end

  def crowdblog_authenticate?
    redirect_to crowdblog.root_path unless crowdblog_is_publisher?
  end

  def current_events
    @current_events = Event.current_events(2)
  end

  def current_posts
    @current_posts = Crowdblog::Post.last_published(3)
  end

  def crowdblog_is_publisher?
    Rails.application.config.publishers
    .delete(' ')
    .split(",")
    .include?(current_identity.email)
  end
end

