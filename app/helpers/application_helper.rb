# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def user_field(name, options = {:size => 16}, selected = nil)
    # select object_name, method, User.find(:all, :conditions => { :active => true}).sort{|a,b| a.to_label <=> b.to_label}.collect{ |a| [a.to_label, a.id] }, {:size => options[:size], :include_blank => true}, :selected => (selected.nil? ? nil : selected.id)
    options = User.find(:all, :conditions => { :active => true}).sort{|a,b| a.to_label.downcase <=> b.to_label.downcase}.collect{|a| "<option value='#{a.id}' #{(!selected.nil? && selected==a) ? 'selected=true' : ''}>#{a.to_label}</option>"}.join("")
    select_tag name, "<option value='' #{selected.nil? ? 'selected=true' : ''}></option>" + options
  end
  
  def adminMode?
    session[:admin_mode]
  end

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
end
