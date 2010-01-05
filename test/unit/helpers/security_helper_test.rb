require File.dirname(__FILE__) + '/../../test_helper'
require 'lib/security_helpers'

class SecurityHelperTest < ActionView::TestCase
  test "byte array to hex string" do
    assert_equal "60ad055b", hex_array2str([-32, 45, 133, -37].pack('c'*4))
  end
  
  test "hex string to byte array" do
    assert_equal [-32, 45, 133, -37].pack('c'*4), hex_str2array("60ad055b")
  end
  
  test "back and forth between string and array" do
    100.times do
      arr = Array.new(rand(100)) {|i| rand(255)-128}
      arr = arr.pack('c'*arr.length)
      assert_equal arr, hex_str2array(hex_array2str(arr))
    end
  end
end