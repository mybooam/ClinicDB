require File.dirname(__FILE__) + '/../test_helper'

class PatientControllerTest < ActionController::TestCase
  fixtures :ethnicities
  fixtures :patients
    
  def setup
    @controller = PatientController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_single_letter
    get :live_search, {:searchtext => "S"}
    assert assigns(:results).length > 0
    
    for pt in assigns(:results)
      puts pt.to_label
      assert pt.to_label =~ /s/i
    end
  end
  
  def test_live_search_full_name
    get :live_search, {:searchtext => "John Smith"}
    assert assigns(:results).length > 0
    assert_equal patients(:john_s), assigns(:results)[0]
    
    for pt in assigns(:results)
      puts pt.to_label
      assert pt.to_label =~ /john/i || pt.to_label =~ /smith/i
    end
  end

  
  def test_live_search_with_comma
    get :live_search, {:searchtext => "Coleman, Bryan"}
    assert assigns(:results).length > 0
    assert_equal patients(:bryan_c), assigns(:results)[0]
    
    for pt in assigns(:results)
      puts pt.to_label
      assert pt.to_label =~ /bryan/i || pt.to_label =~ /coleman/i
    end
  end

  
  def test_live_search_funky
    get :live_search, {:searchtext => "Bryan, ** 12392"}
    assert assigns(:results).length > 0
    
    for pt in assigns(:results)
      puts pt.to_label
      assert pt.to_label =~ /bryan/i
    end
  end
  
  def test_set_patient
    get :set_patient, {:patient_id => patients(:john_s)}
    assert_redirected_to :controller => 'home', :action => "patient_home"
  end
end
