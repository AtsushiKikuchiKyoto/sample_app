module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
    # against session replay attack
    session[:session_token] = user.session_token
  end

  def remember(user)
    user.remember #defin at models/users.rb
    cookies.permanent.encrypted[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user
    if (user_id = session[:user_id])
      user = User.find_by(id: user_id)
      if user && session[:session_token] == user.remember_digest #Q
        @current_user = user
      end
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user&.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    # !current_user.nil?
    current_user.present?
  end

  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end
end
