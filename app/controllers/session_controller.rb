class SessionController < ApplicationController
	
	def start_session
	  if !Session.todayNeedsOne?
	    flash[:notice] = "Session already in progress."
	    redirect_to :controller => :home, :action => :index
    end
    
	  @attendings = Attending.find(:all).sort{|a,b| a.to_label <=> b.to_label}
  end
  
  def create_session
    sess = Session.new()
    sess.attending_id = params[:attending_id]
    sess.session_date = Date.today()
    
    if sess.save
      flash[:notice] = "Session created for today"
      redirect_to :controller => "home", :action => "index"
    else
      flash[:error] = "Session could not be created.  There may already be one for today."
      redirect_to :action => "start_session"
    end
  end
  
  def create_session_with_attending
    att = Attending.new(params[:attending])
    
    if !att.save
      flash[:error] = "Attending could not be created.  There may already be one with that name."
      redirect_to :action => "start_session"
      return
    end
    
    sess = Session.new()
    sess.attending_id = att.id
    sess.session_date = Date.today()
    
    if sess.save
      flash[:notice] = "Session created for today"
      redirect_to :controller => "home", :action => "index"
    else
      flash[:error] = "Session could not be created.  There may already be one for today."
      redirect_to :action => "start_session"
    end
  end
end
