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
  encrypt_with_key(value, getKey)
end

def decrypt_string(value)
  decrypt_with_key(value, getKey)
end

def hash_password(pword) 
  salt = getFingerprintString(Digest::SHA256.digest(pword))
  hex_array2str(Digest::SHA256.digest(pword+salt))
end

private

def loadPasswordFromFile
  if(securityKeyPresent?)
    key_file = "#{securityVolumeDirectory}security/secret.key"
    File.new(key_file, "r").gets
  else
    nil
  end
end

$key = nil
$last_key_check = Time.at(0)

def getKey
  if(Time.now-$last_key_check > 2)
    $key = nil
  end
  
  unless($key)
    pword = loadPasswordFromFile
    $last_key_check=Time.now
    unless(pword)
      #todo: throw exception
      puts "Decrypt key not found"
      $key = nil
    else
      $key = pword2key(pword)
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
  key_str = hex_array2str(key_c)
  len = [key_str.length/8,8].max-1
  sub_str = hex_array2str(key_c)[0..len]
  tr=hex_array2str(Digest::SHA256.digest(sub_str*8))[0..len]
  tr
end

def pword2key(pword)
  Digest::SHA256.digest(pword)
end

def hex_array2str(e)
  e.unpack('c'*e.length).map{|a| (a.to_i+128).to_s(16).rjust(2,'0')}.pack('a2'*e.length)
end

def hex_str2array(s)
  #puts s.unpack('a2'*(s.length/2))
  s.unpack('a2'*(s.length/2)).map{|h| ("0x%s" % h).hex-128}.pack('c'*(s.length/2))
end

def encrypt_with_password(text, pword)
  encrypt_with_key(text, pword2key(pword))
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

def decrypt_with_password(text, pword)
  decrypt_with_key(text, pword2key(pword))
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