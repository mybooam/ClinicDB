class DrugController < ApplicationController
	active_scaffold :drug do |config|
		config.columns = [:name]
	end
	
	def test_new_drug
	  s = params[:drug][:name]
    flash[:notice] = Drug.from_user_string(s)
	  
	  redirect_to :action => 'test_drug'
  end
  
  def new_drug
    @drug_name = ""
    @dose_unit = ""
    if(params[:drug_name] && params[:drug_name].size>0)
      d = Drug.from_user_string(params[:drug_name])
      @drug_name = d.drug_name
      @dose_unit = d.dose_unit
    end
  end
  
  def add_drug
    s = "#{params[:drug][:name]}|#{params[:drug][:dosage]}"
    d = Drug.from_user_string(s)
    
    if !Drug.find(:all).select{|a| a.to_label == d.to_label }.empty?
      flash[:error] = "Drug already exists."
      redirect_to :back
      return
    end
    
    if d.save
      flash[:notice] = "New drug added: #{d.to_label}"
      redirect_to :controller => 'prescription', :action => 'new_for_patient', :drug_id => d.id, :patient_id => params[:patient_id]
    else
      flash[:error] = "Could not add drug #{d.to_label}"
      redirect_to :controller => 'drug', :action => 'new_drug', :drug_name => s, :patient_id => params[:patient_id]
    end
  end
  
  def add_drug_from_manager
    if params['commit'] == "Cancel"
      redirect_to :action => :manage_drugs
      return
    end
    
    drug_name = params[:drug][:name]
    dose_unit = params[:drug][:dosage]
    
    if(dose_unit.strip.length>0)
      s = "#{drug_name}|#{dose_unit}"
    else
      s = drug_name
    end
    
    d = Drug.new(:name => s.strip)
    
    if !Drug.find(:all).select{|a| a.to_label == d.to_label }.empty?
      flash[:error] = "Drug already exists."
      redirect_to :back
      return
    end
    
    if d.save
      flash[:notice] = "New drug added: #{d.to_label}"
      redirect_to :action => :manage_drugs
    else
      flash[:error] = "Could not add drug #{d.to_label}"
      redirect_to :back
    end
  end
  
  def update_drug
    if params['commit'] == "Cancel"
      redirect_to :action => :manage_drugs
      return
    end
    
    d = Drug.find(params[:drug][:drug_id])
    
    drug_name = params[:drug][:drug_name]
    dose_unit = params[:drug][:dose_unit]
    
    if drug_name.size == 0
      flash[:error] = "Cannot have blank name."
      redirect_to :back
      return
    end
    
    if d.save
      flash[:notice] = "Drug updated: #{d.to_label}"
      redirect_to :action => "manage_drugs"
    else
      flash[:error] = "Could not save drug"
      redirect_to :back
    end
  end
  
  def delete_drug
    d = Drug.find(params[:drug_id])
    name = d.to_label
    if d.prescriptions.empty?
      Drug.delete(d.id)
      flash[:notice] = "Drug #{name} deleted."
    else
      flash[:error] = "Drug #{name} could not be deleted"
    end
    
    redirect_to :back
  end
  
  def live_search
    @patient = Patient.find(request.parameters[:patient_id])
    post_sections = request.parameters.delete_if{ |k,v| k=="patient_id" || k=="authenticity_token" || k=="action" || k=="controller" }
    @search_string = post_sections.keys.join(' ')
    if(@search_string.size>0)
      phrases = @search_string.split(' ')
      
      query_all = phrases.collect { |a|
        "(name LIKE '%#{a}%')"
      }.join(" AND ")
    
      @results_start = Drug.find(:all, :conditions => "name LIKE '#{@search_string}%'").sort{|a, b| a.name <=> b.name}
      @results_all = Drug.find(:all, :conditions => query_all).sort{|a, b| a.name <=> b.name}
      
      @results = (@results_start + @results_all).uniq
    end
    
    render(:layout => false)
  end
end
