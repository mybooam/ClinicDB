# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'lib/security_helpers'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => 'c237eedfa42e563fc603e33178c792ac'
  
  before_filter :check_encryption_setup, :unless => proc { |c| c.params[:controller]=="setup" }
  before_filter :check_admin_password_setup, :unless => proc { |c| c.params[:controller]=="setup" }
  before_filter :check_first_user_setup, :unless => proc { |c| c.params[:controller]=="setup" }
  before_filter :check_security, :unless => proc { |c| c.params[:controller]=="setup"}
  before_filter :check_login, :unless => proc { |c| (%w(user:login user:do_login user:logout).include? "#{c.params[:controller]}:#{c.params[:action]}") || c.params[:controller]=="setup"}
  
  $render_start_time = Time.new
  
  def check_encryption_setup
    redirect_to :controller => :setup, :action => :setup_encryption if !Setting.get("key_fingerprint")
  end
  
  def check_admin_password_setup
    redirect_to :controller => :setup, :action => :setup_admin_password if !Setting.get("admin_password")
  end
  
  def check_first_user_setup
    redirect_to :controller => :setup, :action => :setup_first_user if User.find(:all).empty?
  end
  
  def check_security
    unless security_unlocked?
#      puts "Security is not unlocked"
      redirect_to :controller =>'home', :action => 'security_error' 
    else
#      puts "Security is unlocked"
    end
  end
  
  def check_login
    if session[:user] == nil || session[:last_action] == nil || session[:last_action] < Setting.get_i("user_timeout_sec", 300).seconds.ago
      redirect_to :controller => 'user', :action => 'logout'
      return
    else
      session[:last_action] = Time.now
    end
  end
end
