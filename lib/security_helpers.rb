require "find"

def securityKeyPresent?
  Dir.new("/Volumes/").each do |volume| 
    if File.exist?("/Volumes/#{volume}/security/secret.key") && File.exist?("/Volumes/#{volume}/security/secret.fingerprint")
      return true
    end
  end
  return false
end

def securityVolumeDirectory
  Dir.new("/Volumes/").each do |volume| 
    if File.exist?("/Volumes/#{volume}/security/secret.key") && File.exist?("/Volumes/#{volume}/security/secret.fingerprint")
      return "/Volumes/#{volume}/"
    end
  end
  return nil
end