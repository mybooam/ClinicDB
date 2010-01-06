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
  
  test "likely hex string test" do
    assert is_likely_hex_string?("abcdef1234567890")
    assert is_likely_hex_string?("1")
    
    assert !is_likely_hex_string?("z")
    assert !is_likely_hex_string?("h")
    assert !is_likely_hex_string?("hhhhh")
    assert !is_likely_hex_string?("g")
    assert !is_likely_hex_string?("abcdefg1234567890")
    assert !is_likely_hex_string?("-&*^%@^%!(")
    assert !is_likely_hex_string?("gabcdef1234567890")
    assert !is_likely_hex_string?("abcdef1234567890g")
    assert !is_likely_hex_string?("gabcdef1234567890g")
    100.times do
      assert is_likely_hex_string?(hex_array2str(OpenSSL::Cipher::Cipher.new("aes-256-cbc").random_key))
    end
    100.times do
      assert !is_likely_hex_string?(OpenSSL::Cipher::Cipher.new("aes-256-cbc").random_key+"g")
    end
  end
  
  test "encrypt and decrypt known" do
    key = hex_str2array("03dc70677e0c8e7c5c8f307cc9c33f5b09b132b5c875028e804b1315966d4f8f")
    str = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Maecenas egestas nibh in felis suscipit vitae faucibus nibh placerat. Donec orci felis, commodo et elementum quis, bibendum a purus. Sed quis augue non ipsum congue feugiat in id purus. Morbi gravida, tellus auctor eleifend consequat, nisi odio eleifend massa, non porta metus est ac sem. Duis vestibulum mauris vel dui convallis consequat. Ut et mauris vestibulum dolor vulputate laoreet ut in diam. Phasellus tincidunt eleifend nisi, eu mollis ligula pretium eget. Proin odio dui, euismod a volutpat ut, tristique ac arcu. Fusce congue ullamcorper pretium. Aliquam erat volutpat. Suspendisse varius varius elit a sodales."
    correct = "d3982d32ca2966978c17bcc451042a6a603bb7367a53fd178641842e17fd7cdcb8a8e25f57359fdc5f4f84e838fdba6a2bf11d9618932e6cdc3a1fe40f6ea7b9a8f45f4667f09d65959ff8f599ad8e25ba7b2986d3685ea619c12c6a950fdfb09fa57f60f0a78d88fae0de4508e12f4c44118c333ab7b0aa8246762b536b3c65e40344941797bc236bb77809cd79f0b8b238f62004afca3aeb0efbd613f01406dea5fca1a92cb655d3096fc0e40061c15c3d400d197e3176805e4e2f0cc43a85e5fd7a6b742af6d2aa6eb992317c4cf49f039e86bef6cab00440e66299dbf6d088de7c71c0c2b51919570253a3526ef6bd3082f6e94213e4dfed931529e076121437bfeecc701690a19d7361f55bc604a333f496bbb6f588b5c4b363898eeaeeb43ac695c66a5997dd5142c7e1b6513dff64495dfe53e5ea8563a51585d70a6e7d6190374dd035d09e3bed4a51f003393c70a96db77dcd92430962c0beae69e36b9819a618e53a934694704900cda027740af9356d45b3bc52dbdb3da0dcc068750edc9611ecacc638ce75c3b1c3cff4c3dbfaff121b2f587cad2865ae02feade0f55ac79cfc9208e797017090e3e8ae3a1c601f5627d5e3e0fe1e4a127d964a49fdbdf079cfec83a6485cf6111fc23bbd0fea73ae4c8fb2ad1dc9e32b591dda6a4a2286b8a6cbbac13a4006e2f8354411cd58f5347dc8bf4da9a7a1d4a085022386e414328e8b796cd29c19536b826f1adb9917a2682f54ea66e1436e47a82716a1b2315eb8c4f41784d1b301cf440d63552141187267de890bc36f4720aab2fa496e48b9d8a87d4f423beb67c6f5a85faf49a5fcf0bd09e6885540bc3b3801c49f369e2e9c7b3cbe457ed898d2bb2ef056e47fd6ca59f66a049d2685c3e29c79c96fbd9c0226f6ac541a3c9eed94795f6a835eef11a3c083b50d5a281682a79aef118c8fe2316b27f320363b2239dd"
    enc = encrypt_with_key(str, key)
    
    assert_equal correct, enc
    assert_equal str, decrypt_with_key(enc, key)
    assert_equal str, decrypt_with_key(correct, key)
    
  end
  
  test "encrypt and decrypt random" do
    100.times do
      key = OpenSSL::Cipher::Cipher.new("aes-256-cbc").random_key
      text = hex_array2str(OpenSSL::Cipher::Cipher.new("aes-256-cbc").random_key)
      assert_equal text, decrypt_with_key(encrypt_with_key(text, key), key)
    end
  end
end