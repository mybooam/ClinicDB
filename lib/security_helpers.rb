require "find"

def securityKeyPresent?
  Dir.new("/Volumes/").each do |volume| 
    if File.exist?("/Volumes/#{volume}/security/secret.key") # && File.exist?("/Volumes/#{volume}/security/secret.fingerprint")
      return true
    end
  end
  return false
end

def securityVolumeDirectory
  Dir.new("/Volumes/").each do |volume| 
    if File.exist?("/Volumes/#{volume}/security/secret.key") # && File.exist?("/Volumes/#{volume}/security/secret.fingerprint")
      return "/Volumes/#{volume}/"
    end
  end
  return nil
end

def security_unlocked?
  getKey!=nil
end

def encrypt_string(value)
  unless $security_helper_in_reset_mode
    encrypt_with_key(value, getKey(:encrypt))
  else
    encrypt_with_key(value, $security_helper_reset_mode_new_key)
  end
end

def decrypt_string(value)
  unless $security_helper_in_reset_mode
    decrypt_with_key(value, getKey(:decrypt))
  else
    begin
      decrypt_with_key(value, getKey(:decrypt))
    rescue OpenSSL::Cipher::CipherError
      decrypt_with_key(value, $security_helper_reset_mode_new_key)
    end
  end

end

def hash_password(pword) 
  salt = getFingerprintString(Digest::SHA256.digest(pword))
  hex_array2str(Digest::SHA256.digest(pword+salt))
end

def write_old_and_new_key_files(new_key)
  old_key_file_path = "#{securityVolumeDirectory}security/secret.key.old"
  old_key_file = File.new(old_key_file_path, "w")
  old_key_file.write(hex_array2str(getKey))
  old_key_file.close
  
  new_key_file_path = "#{securityVolumeDirectory}security/secret.key.new"
  new_key_file = File.new(new_key_file_path, "w")
  new_key_file.write(hex_array2str(new_key))
  new_key_file.close
  
end

def set_security_key(new_key)
  fp = getFingerprintString(new_key)
  key_file = "#{securityVolumeDirectory}security/secret.key"
  f = File.new(key_file, "w")
  f.write(hex_array2str(new_key))
  f.close
  Setting.set("key_fingerprint",fp)
  $key = nil
end

private

#def loadPasswordFromFile
#  if(securityKeyPresent?)
#    key_file = "#{securityVolumeDirectory}security/secret.key"
#    File.new(key_file, "r").gets
#  else
#    nil
#  end
#end

def loadKeyFromFile(key_file_name = "secret.key")
  if(securityKeyPresent?)
    key_file = "#{securityVolumeDirectory}security/#{key_file_name}"
    k = File.new(key_file, "r").gets
    if is_likely_hex_string?(k) && k.length==64
#      puts "normal sized key"
      k
    elsif k.length==32
#      puts "not a normal sized key, but 32 bytes"
      hex_array2str(k)
    else
#      puts "not a normal sized key"
      s = hex_array2str(Digest::SHA256.digest(k))
      puts s
      s
    end
  else
    nil
  end
end

def is_likely_hex_string?(str)
  str =~ /^[A-Fa-f0-9]*$/
end

@security_helper_in_reset_mode = false
@security_helper_reset_mode_new_key = nil

$key = nil
$last_key_check = Time.at(0)

def getKey(mode=:decrypt)
  if(Time.now-$last_key_check > 2)
    $key = nil
  end
  
  unless($key)
    key_str = loadKeyFromFile
    $last_key_check=Time.now
    unless(key_str)
      puts "Decrypt key not found"
      $key = nil
    else
      $key = hex_str2array(key_str)
      fp = getFingerprintString($key)
#      puts "Decrypt key reloaded => #{fp}"
      actual_fp = Setting.get("key_fingerprint")
      if(actual_fp==fp)
#        puts "Fingerprint matched"
      else
        puts "Fingerprint not matched! Found: #{fp}, Should be: #{actual_fp}"
        $key = nil
      end
    end
  end
  $key
end

def getFingerprintString(key_c) 
  key_str = hex_array2str(Digest::SHA256.digest(key_c))
  sub_str = key_str[0..7]
  tr=hex_array2str(Digest::SHA256.digest(sub_str*8))[0..7]
  tr
end

def hex_array2str(e)
  e.unpack('c'*e.length).map{|a| (a.to_i+128).to_s(16).rjust(2,'0')}.pack('a2'*e.length)
end

def hex_str2array(s)
  #puts s.unpack('a2'*(s.length/2))
  s.unpack('a2'*(s.length/2)).map{|h| ("0x%s" % h).hex-128}.pack('c'*(s.length/2))
end

def encrypt_with_key(text, key)
  if(text.length==0)
    return ""
  end
  
  # puts "Encrypting #{text}"
  c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
  c.encrypt
  c.key = key
#  puts key.unpack('c'*key.length).map{|a| (a.to_i+128).to_s(16).rjust(2,'0')}.pack('a2'*key.length)
  e = c.update(text);
  e << c.final;
  # puts "Encrypted: #{hex_array2str(e)}"
  hex_array2str(e)
end

def decrypt_with_key(text, key)
  if(text.length==0)
    return ""
  end
  
  # puts "Decrypting #{text}"
  c = OpenSSL::Cipher::Cipher.new("aes-256-cbc")
  c.decrypt
  c.key = key
  e = hex_str2array(text)
  d = c.update(e)
  d << c.final
  # puts "Decrypted: #{d}"
  d
end