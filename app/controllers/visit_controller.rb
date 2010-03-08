class VisitController < ApplicationController
	def new_for_patient
    @visit = Visit.new
    
    @patient = Patient.find(params[:patient_id])
    @visit.version = params[:version] || Visit.current_version
    
    render :edit_visit
  end
  
  def edit_visit
    @visit = Visit.find(params[:visit_id])
    @patient = Patient.find(@visit.patient_id)
    @version = @visit.version
  end
  
  def add_or_update
    puts "add or update"
    puts params.collect{|a,b| "#{a} -> #{b}"}.join(" | ")
    
    visit = Visit.new_or_update_from_params(params)
    if visit
      if params[:auto_save] == 'true'
        flash[:notice] = "Visit auto-saved."
        redirect_to :action => :edit_visit, :visit_id => visit.id and return
      else
        flash[:notice] = "Visit saved."
        redirect_to :controller => :home, :action => :patient_home, :patient_id => visit.patient.id and return
      end
    else
      flash[:error] = "Visit could not be #{params[:auto_save] ? 'auto-saved' : 'saved'}"
      redirect_to :back and return
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
  
  def delete_visit
    unless adminMode?
      flash[:error] = "Cannot delete a visit unless you are in admin mode."
      redirect_to :back and return
    end
    
    @visit = Visit.find(params[:visit_id])
    
    unless @visit
      flash[:error] = "Invalid visit."
      redirect_to :back and return
    end
    
    unless params[:confirm]=='yes'
      render :action => "delete_visit_confirm" and return
    end
    
    patient = @visit.patient
    
    Visit.destroy(params[:visit_id])
    
    redirect_to :controller => 'home', :action => 'patient_home', :patient_id => patient.id and return
  end
  
  def print_attending_form
    respond_to do |format|
      format.html { redirect_to :back }
      format.pdf { render :layout => false }
    end
  end
end
