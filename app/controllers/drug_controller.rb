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
  
  def live_search
    @patient = Patient.find(request.parameters[:patient_id])
    post_sections = request.parameters.delete_if{ |k,v| k=="patient_id" || k=="authenticity_token" || k=="action" || k=="controller" }
    @search_string = post_sections.keys.join(' ')
    if(@search_string.size>0)
      phrases = @search_string.split(' ')
    
      query_any = phrases.collect { |a|
        "(name LIKE '%#{a}%')"
      }.join(" OR ")
      
      query_all = phrases.collect { |a|
        "(name LIKE '%#{a}%')"
      }.join(" AND ")
    
      @results_all = Drug.find(:all, :conditions => query_all).sort{|a, b| a.name <=> b.name}
      @results_any = Drug.find(:all, :conditions => query_any).sort{|a, b| a.name <=> b.name}
      
      @results = (@results_all + @results_any).uniq
    end
    
    render(:layout => false)
  end
end
