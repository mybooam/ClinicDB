class SettingController < ApplicationController
  active_scaffold :settings do |config|
      config.label = "Settings"
      config.columns = [:key, :value]
      list.sorting = [{:key => 'ASC'}]
      columns[:key].label = "Key"
      columns[:value].label = "Value"
      columns[:key].form_ui = :textarea
      columns[:value].form_ui = :textarea
      columns[:key].options = {:rows => 1, :columns => 40}
      columns[:value].options = {:rows => 2, :columns => 60}
    end
  
  before_filter :check_admin_for_settings
  
  def check_admin_for_settings
    unless adminMode?
      flash[:error] = "Settings may only be changed in Admin Mode."
      redirect_to :controller=>:home, :action=>:index and return
    end
  end
  
  def manager
    @all_settings = %w(key_fingerprint 
      admin_password 
      user_timeout_sec 
      patient_search_result_size 
      visit_form_auto_save_delay_ms
      visit_form_activity_period_min
      close_patient_home_time_sec
      fuzzy_patient_search)
      
    @settings = Setting.find(:all).sort{|a,b| a.key <=> b.key}
    
    @unused = @all_settings.select{|a| !@settings.collect{|b| b.key}.include? a}
  end
  
  def set
    key = params[:setting][:key]
    value = params[:setting][:value]
    if Setting.set(key, value)
      flash[:notice] = "Saved #{key} = #{value}"
      redirect_to :action => :manager and return
    else
      flash[:error] = "Could not set #{key} = #{value}"
      redirect_to :back and return
    end
  end
  
  def delete
    Setting.destroy(params[:id])
    flash[:notice] = "Setting deleted"
    redirect_to :action => :manager
  end
end
