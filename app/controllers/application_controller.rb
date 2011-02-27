# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

require 'lib/security_helpers'
require 'lib/file_helpers'

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  include ApplicationHelper

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
end
