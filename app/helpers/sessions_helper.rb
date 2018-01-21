module SessionsHelper
  def logged_in?
    return true if !session[:id].nil?

    authenticate_or_request_with_http_basic do |username, password|
        return username == ENV["USERNAME"] && password == ENV["PASSWORD"]
    end
  end
end
