class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

   helper_method :current_user
   protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }
  # def current_user
  # 	@current_user = $username
  # 	@current_user_p = $password
  # end
  

end
