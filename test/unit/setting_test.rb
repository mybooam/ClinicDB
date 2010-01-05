require File.dirname(__FILE__) + '/../test_helper'

class SettingTest < ActiveSupport::TestCase
  test "blank db" do
    assert_equal("", Setting.get("key1"))
    assert_equal("", Setting.get("key2"))
    assert_equal("", Setting.get("asdfasdf"))
    assert_equal("", Setting.get(""))
  end
  
  test "new setting in blank db" do
    assert_equal Setting.get("key1"), ""
    Setting.set("key1", "value1")
    assert_equal "value1", Setting.get("key1")
  end
  
  test "change setting" do
    assert_equal Setting.get("key1"), ""
    Setting.set("key1", "value1")
    assert_equal "value1", Setting.get("key1")
    Setting.set("key1", "value2")
    assert_equal "value2", Setting.get("key1")
  end
  
  test "don't allow blank setting" do
    assert !Setting.new.save
    assert_equal "", Setting.get("")
  end
  
  test "don't allow blank key" do
    Setting.set("", "value1")
    assert_equal "", Setting.get("")
    Setting.set("", "value2")
    assert_equal "", Setting.get("")
  end
end
