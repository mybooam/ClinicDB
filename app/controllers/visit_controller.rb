class VisitController < ApplicationController
	def new_for_patient
    @visit = Visit.new
    @patient = Patient.find(params[:patient_id])
    render "/visit/#{Visit.current_version}/new_for_patient", :layout => 'application'
  end
	
	def add_for_patient
    visit = Visit.new(params[:visit])
    visit.visit_date = Date.today()
    if(visit.temperature)
      if(visit.temperature < 50)
        visit.temperature = visit.temperature * 1.8 + 32
      end
    end
    visit.users = []
    
    if params[:users_id1] && params[:users_id1] != ""
      visit.users << User.find(params[:users_id1])
    end
    if params[:users_id2] && params[:users_id2] != ""
      visit.users << User.find(params[:users_id2])
    end
    
    if visit.save
      Transaction.log_edit_patient(session[:user].id, params[:visit][:patient_id])
      redirect_to :controller => 'home', :action => 'patient_home', :patient_id => params[:visit][:patient_id]
    else
      redirect_to :back
    end
  end
  
  def edit_visit
    @visit = Visit.find(params[:visit_id])
    @patient = Patient.find(@visit.patient_id)
    render "/visit/#{@visit.version}/edit_visit", :layout => 'application'
  end
  
  def update_visit
    Visit.update(params[:visit_id][:visit_id], params[:visit])
    
    visit = Visit.find(params[:visit_id][:visit_id], :include => [:patient])
    if(visit.temperature)
      if(visit.temperature < 50)
        visit.temperature = visit.temperature * 1.8 + 32
      end
    end
    visit.users = []
    
    if params[:users_id1] && params[:users_id1]!=""
      visit.users << User.find(params[:users_id1])
    end
    if params[:users_id2] && params[:users_id2]!=""
      visit.users << User.find(params[:users_id2])
    end
    
    if visit.save
      flash[:notice] = "#{visit.patient.properLastName}'s visit on #{visit.visit_date} was successfully updated."
      Transaction.log_edit_patient(session[:user].id, visit.patient.id)
      redirect_to :controller => 'home', :action => 'patient_home', :patient_id => visit.patient.id
    else
      flash[:notice] = "Visit update failed."
      redirect_to :back
    end
  end
  
  def show_visit
    @visit = Visit.find(params[:visit_id])
  end
  
  def print_visit
    @visit = Visit.find(params[:id])
    
    respond_to do |format|
      format.html { redirect_to :action => :show_visit, :visit_id => @visit.id }
      format.pdf { render :layout => false }
    end
  end
end
