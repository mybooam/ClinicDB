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
  
  def add_user
    user = User.new(params[:user])
    
    if !User.find(:all).select{|a| a.first_name==user.first_name && a.last_name==user.last_name }.empty?
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
      flash[:notice] = "User #{user.to_label} updated successfully."
      redirect_to :action => :manager
    else
      flash[:error] = "Could not update user."
      redirect_to :back
    end
  end
  
  def set_code
    user = User.find(params[:user_id][:user_id])
    
    unless(params[:user][:access_code_1]==params[:user][:access_code_2])
      flash[:error] = "Access codes do not match"
      redirect_to :back
      return
    end
    
    other = User.by_access_code(params[:user][:access_code_1])
    if (other != nil) && (other.id != user.id)
      flash[:error] = "Access code already in use"
      redirect_to :back
      return
    end
    
    user.access_hash = User.hash_access_code(params[:user][:access_code_1])
    
    unless(user.save)
      flash[:error] = "Error saving user"
      redirect_to :back
      return
    end
    
    flash[:notice] = "Access code set"
    redirect_to :controller => :user, :action => :manager
  end
  
  def do_login
    user = User.by_access_code(params[:access_code])
    if(user==nil) 
      flash[:error] = "Incorrect access code"
      session[:user] = nil
      redirect_to :controller => :user, :action => :login
      return
    end
    
    flash[:notice] = "User #{user.to_label} logged in."
    session[:user] = user
    redirect_to :controller => :home, :action => :index
  end
  
  def logout
    reset_session
    redirect_to :controller => :home, :action => :index
  end
end
