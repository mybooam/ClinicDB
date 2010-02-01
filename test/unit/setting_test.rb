require File.dirname(__FILE__) + '/../test_helper'

class SettingTest < ActiveSupport::TestCase
  test "blank db" do
    assert_nil Setting.get("key1")
    assert_nil Setting.get("key2")
    assert_nil Setting.get("asdfasdf")
    assert_nil Setting.get("")
  end
  
  test "new setting in blank db" do
    assert_nil Setting.get("key1")
    Setting.set("key1", "value1")
    assert_equal "value1", Setting.get("key1")
  end
  
  test "change setting" do
    assert_nil Setting.get("key1")
    Setting.set("key1", "value1")
    assert_equal "value1", Setting.get("key1")
    Setting.set("key1", "value2")
    assert_equal "value2", Setting.get("key1")
  end
  
  test "don't allow blank setting" do
    assert !Setting.new.save
    assert_nil Setting.get("")
  end
  
  test "don't allow blank key" do
    Setting.set("", "value1")
    assert_nil Setting.get("")
    Setting.set("", "value2")
    assert_nil Setting.get("")
  end
  
  test "return default when bad key" do
    Setting.set("key1", "value1")
    assert_equal "value1", Setting.get("key1")
    
    assert_nil Setting.get("bad_key")
    assert_equal "def", Setting.get("bad_key", "def")
    assert_equal "asdf", Setting.get("bad_key", "asdf")
    assert_equal "3", Setting.get("bad_key", 3.to_s)
    assert_equal 3, Setting.get("bad_key", 3.to_s).to_i
    assert_equal "value1", Setting.get("key1","asdf")
  end
  
  test "get_i" do
    Setting.set("key1", "5")
    assert_equal 5, Setting.get_i("key1")
    assert_equal 5, Setting.get_i("key1",123)
    assert_equal 0, Setting.get_i("key2")
    assert_equal 3, Setting.get_i("key2", 3)
    assert_equal -3, Setting.get_i("key2", -3)
    
    Setting.set("key1", "-14")
    assert_equal -14, Setting.get_i("key1")
    assert_equal -14, Setting.get_i("key1",4)
    
    
    Setting.set("bad_key", "hello")
    assert_equal 0, Setting.get_i("bad_key")
    assert_equal 3, Setting.get_i("bad_key", 3)
    assert_equal 123122, Setting.get_i("bad_key", 123122)
    
    assert_equal 0, Setting.get_i("no_key")
    assert_equal 3, Setting.get_i("no_key", 3)
    assert_equal 123122, Setting.get_i("no_key", 123122)
  end
  
  test "get_f" do
    Setting.set("key1", "5.14")
    assert_equal 5.14, Setting.get_f("key1")
    assert_equal 5.14, Setting.get_f("key1",123.45)
    assert_equal 0, Setting.get_f("key2")
    assert_equal 3.2, Setting.get_f("key2", 3.2)
    assert_equal -3, Setting.get_f("key2", -3)
    
    Setting.set("key1", "-14")
    assert_equal -14, Setting.get_f("key1")
    assert_equal -14, Setting.get_f("key1",4)
    
    Setting.set("key1", "-14.0")
    assert_equal -14, Setting.get_f("key1")
    assert_equal -14, Setting.get_f("key1",4)
    
    Setting.set("key1", "-.14")
    assert_equal -0.14, Setting.get_f("key1")
    assert_equal -0.14, Setting.get_f("key1",4)
    
    Setting.set("key1", "-0.14")
    assert_equal -0.14, Setting.get_f("key1")
    assert_equal -0.14, Setting.get_f("key1",4)
    
    Setting.set("bad_key", "hello")
    assert_equal 0, Setting.get_f("bad_key")
    assert_equal 3, Setting.get_f("bad_key", 3)
    assert_equal 123122, Setting.get_f("bad_key", 123122)
    
    assert_equal 0, Setting.get_f("no_key")
    assert_equal 3, Setting.get_f("no_key", 3)
    assert_equal 123122, Setting.get_f("no_key", 123122)
  end
end
