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
      pword="0"
    end
    $key = pword2key(pword)
    puts "Password reloaded"
  end
  $key
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