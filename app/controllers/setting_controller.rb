class SettingController < ApplicationController
  active_scaffold :settings do |config|
      config.label = "Settings"
      config.columns = [:key, :value]
      list.sorting = [{:key => 'ASC'}]
      columns[:key].label = "Key"
      columns[:value].label = "Value"
    end
  
  before_filter :check_admin_for_settings
  
  def check_admin_for_settings
    unless adminMode?
      flash[:error] = "Settings may only be changed in Admin Mode."
      redirect_to :controller=>:home, :action=>:index and return
    end
  end
end
