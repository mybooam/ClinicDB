class UserController < ApplicationController
	active_scaffold :user do |config|
    config.label = "Users"
    config.columns = [:first_name, :last_name, :email, :active, :visits, :access_hash]
    config.update.columns.exclude :visits
    config.create.columns.exclude :visits
    list.sorting = [{:last_name => 'ASC'}, {:first_name => 'ASC'}, {:email => 'ASC'}]
    columns[:last_name].label = "Last Name"
    columns[:first_name].label = "First Name"
    columns[:active].label = "Active"
    columns[:active].form_ui = :checkbox
  end
  
  def manager
    @users = User.find(:all)
    @sort_by = params[:sort_by] || "last_name_fwd"

    case @sort_by
    when "id_fwd" then
      @users.sort!{|a,b| a.id <=> b.id}
    when "id_back" then
      @users.sort!{|a,b| b.id <=> a.id}
    when "first_name_fwd" then
      @users.sort!{|a,b| "#{a.first_name}#{a.last_name}" <=> "#{b.first_name}#{b.last_name}"}
    when "first_name_back" then
      @users.sort!{|a,b| "#{b.first_name}#{b.last_name}" <=> "#{a.first_name}#{a.last_name}"}
    when "last_name_fwd" then
      @users.sort!{|a,b| "#{a.last_name}#{a.first_name}" <=> "#{b.last_name}#{b.first_name}"}
    when "last_name_back" then
      @users.sort!{|a,b| "#{b.last_name}#{b.first_name}" <=> "#{a.last_name}#{a.first_name}"}
    when "active_fwd" then
      @users.sort!{|a,b| a.to_label <=> b.to_label}
      @users.sort!{|a,b| "#{a.active}#{a.active}" <=> "#{b.active}#{b.active}"}
    when "active_back" then
      @users.sort!{|a,b| a.to_label <=> b.to_label}
      @users.sort!{|a,b| "#{b.active}#{b.active}" <=> "#{a.active}#{a.active}"}
    when "admin" then
      @users.sort!{|a,b| (a.can_be_admin ? "a" : "b") <=> (b.can_be_admin ? "a" : "b")}
    end
  end
  
  def manage_action
    user_ids = params[:user_select].select{|k,v| v=='1'}.collect{|a| a[0]}
    activate = (params[:commit].downcase =~ /^activate/) ? true : false
    user_ids.each do |id|
      unless User.update(id, :active => activate)
        flash[:error] = "One or more user(s) could not be updated."
      end
    end
    redirect_to :action => :manager
  end
  
  def add_user
    ac1 = params[:access_code][:ac1]
    ac2 = params[:access_code][:ac2]
    
    unless ac1==ac2
      flash[:error] = "Access codes do not match"
      redirect_to :back
      return
    end
    
    unless /\A[a-zA-Z0-9]{4}\Z/ =~ ac1 && /\A[a-zA-Z0-9]{4}\Z/ =~ ac2
      flash[:error] = "Access codes must be four alpha-numeric characters long"
      redirect_to :back
      return
    end
    
    if User.by_access_code(ac1) != nil
      flash[:error] = "Access code already in use"
      redirect_to :back
      return
    end
    
    user = User.new(params[:user])
    user.access_hash = User.hash_access_code(ac1)
    
    unless User.find(:all).select{|a| a.first_name==user.first_name && a.last_name==user.last_name }.empty?
      flash[:error] = "User #{user.to_label} already exists."
      redirect_to :back
      return
    end
    
    if user.save
      flash[:notice] = "User #{user.to_label} created."
    else
      flash[:error] = "Could not save user."
    end
    
    redirect_to :back
  end
  
  def delete_user
    if User.delete(params[:user_id])
      flash[:notice] = "User deleted successfully."
    else
      flash[:notice] = "User could not be deleted."
    end
    
    redirect_to :back
  end
  
  def update_user
    if User.update(params[:user_id][:user_id], params[:user])
      user = User.find(params[:user_id][:user_id])
      if session[:user].id == user.id && !user.can_be_admin
        user.can_be_admin = true
        user.save
        flash[:error] = "Current user cannot lose admin privilege."
        redirect_to :back and return
      end
      flash[:notice] = "User #{user.to_label} updated successfully."
      redirect_to :action => :manager
    else
      flash[:error] = "Could not update user."
      redirect_to :back
    end
  end
  
  def set_code
    user = User.find(params[:user_id][:user_id])
    
    ac1 = params[:user][:access_code_1]
    ac2 = params[:user][:access_code_2]
    
    unless ac1==ac2
      flash[:error] = "Access codes do not match"
      redirect_to :back
      return
    end
    
    unless /\A[a-zA-Z0-9]{4}\Z/ =~ ac1 && /\A[a-zA-Z0-9]{4}\Z/ =~ ac2
      flash[:error] = "Access codes must be four alpha-numeric characters long"
      redirect_to :back
      return
    end
    
    other = User.by_access_code(ac1)
    if (other != nil) && (other.id != user.id)
      flash[:error] = "Access code already in use"
      redirect_to :back
      return
    end
    
    user.access_hash = User.hash_access_code(ac1)
    
    unless(user.save)
      flash[:error] = "Error saving user"
      redirect_to :back
      return
    end
    
    flash[:notice] = "Access code set"
    redirect_to :controller => :user, :action => :manager
  end
  
  def login
    render :layout => "login_layout"
  end
  
  def do_login
    unless /\A[a-zA-Z0-9]{4}\Z/ =~ params[:access_code]
      flash[:error] = "Incorrect access code"
      session[:user] = nil
      redirect_to :controller => :user, :action => :login
      return
    end
    
    user = User.by_access_code(params[:access_code])
    if(user==nil) 
      flash[:error] = "Incorrect access code"
      session[:user] = nil
      redirect_to :controller => :user, :action => :login
      return
    end
    
    unless user.active?
      flash[:error] = "User is no longer active.  Please contact the administrator."
      session[:user] = nil
      redirect_to :controller => :user, :action => :login
      return
    end
    
    flash[:notice] = "User #{user.to_label} logged in."
    session[:user] = user
    session[:last_action] = Time.now
    redirect_to :controller => :home, :action => :index
  end
  
  def logout
    flash[:warning] = "You have been logged out"
    reset_session
    redirect_to :controller => :user, :action => :login
  end
end
