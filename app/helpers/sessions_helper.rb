module SessionsHelper
  def logged_in?
    return !session[:id].nil?
  end
end
