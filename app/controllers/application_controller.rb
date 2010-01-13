# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'lib/security_helpers'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c237eedfa42e563fc603e33178c792ac'
  
  before_filter :check_security, :unless => proc { |c| %w(home:status home:security_error).include? "#{c.params[:controller]}:#{c.params[:action]}" }
  before_filter :check_login, :unless => proc { |c| %w(user:login user:do_login home:security_error home:status).include? "#{c.params[:controller]}:#{c.params[:action]}" }
  
  $render_start_time = Time.new
  
  def check_security
    unless security_unlocked?
#      puts "Security is not unlocked"
      redirect_to :controller =>'home', :action => 'security_error' 
    else
#      puts "Security is unlocked"
    end
  end
  
  def check_login
    unless session[:user] != nil
      puts "not logged in"
      redirect_to :controller => 'user', :action => 'login'
      return
    end
    puts "logged in as #{session[:user].to_label}"
  end
end
