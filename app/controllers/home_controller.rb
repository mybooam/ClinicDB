class HomeController < ApplicationController
  def index
    @all_tb_tests = TbTest.find(:all)
    @tb_tests_open = TbTest.find(:all).select { |item| 
      (item.result == nil || item.result == "") && item.given_date + 2 <= Date.today
    }
  end

  def new_patient
  end
  
  def existing_patient
  end
end