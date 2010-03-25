# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'lib/security_helpers'
require 'lib/file_helpers'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery # :secret => 'c237eedfa42e563fc603e33178c792ac'
	# removed this for now since it is causing some issues with saving visits.  I can't reproduce the problem - pkinney  

  before_filter :check_encryption_setup, :unless => proc { |c| c.params[:controller]=="setup"||RAILS_ENV == 'test' }
  before_filter :check_admin_password_setup, :unless => proc { |c| c.params[:controller]=="setup"||RAILS_ENV == 'test' }
  before_filter :check_first_user_setup, :unless => proc { |c| c.params[:controller]=="setup"||RAILS_ENV == 'test' }
  before_filter :check_security, :unless => proc { |c| c.params[:controller]=="setup"||RAILS_ENV == 'test'}
  before_filter :check_browser, :unless => proc { |c| c.params[:controller]=="setup"||(%w(user:login user:do_login user:logout).include? "#{c.params[:controller]}:#{c.params[:action]}")||RAILS_ENV == 'test'}
  before_filter :check_login, :unless => proc { |c| (%w(user:login user:do_login user:logout).include? "#{c.params[:controller]}:#{c.params[:action]}") || c.params[:controller]=="setup"||RAILS_ENV == 'test'}
  
  $render_start_time = Time.new
  
  def check_encryption_setup
    redirect_to :controller => :setup, :action => :setup_encryption if !Setting.get("key_fingerprint")
  end
  
  def check_admin_password_setup
    redirect_to :controller => :setup, :action => :setup_admin_password if !Setting.get("admin_password")
  end
  
  def check_first_user_setup
    redirect_to :controller => :setup, :action => :setup_first_user if User.find(:all).select{|u| u.access_hash && u.access_hash!=""}.empty?
  end
  
  def check_security
    unless security_unlocked?
#      puts "Security is not unlocked"
      redirect_to :controller =>'setup', :action => 'security_error' 
    else
#      puts "Security is unlocked"
    end
  end
  
  def check_login
    if session[:user] == nil || session[:last_action] == nil || session[:last_action] < Setting.get_i("user_timeout_sec", 300).seconds.ago
      redirect_to :controller => 'user', :action => 'logout' and return
    else
      session[:last_action] = Time.now
    end
  end
  
  def check_browser
    unless %w(gecko safari).include? browser_name(request)
      redirect_to :controller => 'setup', :action => 'incompatible_browser', :browser_name => browser_name(request) and return unless session[:ignore_incompatible_browser]
    end
  end
  
  def adminMode?
    session[:admin_mode]
  end
end
