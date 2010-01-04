class SettingController < ApplicationController
  active_scaffold :settings do |config|
      config.label = "Settings"
      config.columns = [:key, :value]
      list.sorting = [{:key => 'ASC'}]
      columns[:key].label = "Key"
      columns[:value].label = "Value"
    end
end
