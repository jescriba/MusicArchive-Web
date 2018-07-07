module SessionsHelper
  def logged_in?
    return true if !session[:id].nil? || ActionController::HttpAuthentication::Basic.encode_credentials(ENV["USERNAME"], ENV["PASSWORD"]) == request.headers["HTTP_AUTHORIZATION"]
    return false
    # TODO Fix: this currently causes double render issues
    # auth = authenticate_or_request_with_http_basic do |username, password|
    #     return username == ENV["USERNAME"] && password == ENV["PASSWORD"]
    # end
  end
end
