class UserController < ApplicationController
	active_scaffold :user do |config|
      config.label = "Users"
      config.columns = [:first_name, :last_name, :email, :active, :visits]
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
end
