require 'lib/security_helpers'

class SetupController < ApplicationController
  # This method should run if encryption is not set up and there is no security.key file available
  # Here the user should receive instructions on how to setup a USB key.
  def setup_security_key
    if securityKeyPresent?
      redirect_to :controller => :setup, :action => :setup_encryption
      return
    end
    rkey = OpenSSL::Cipher::Cipher.new("aes-256-cbc").random_key
    @suggest = hex_array2str(rkey)
    @volumes = getVolumes
    render :layout => "security_error"
  end

  def setup_security_key_manually
    
  end

  def create_key_file
    if securityKeyPresent?
      flash[:error] = "Cannot create new key file as one already exists."
      redirect_to :back
      return
    end

    write_key_file(params[:volume], params[:key])
    unless securityKeyPresent?
      flash[:error] = "Key could not be created, please create it manually"
      redirect_to :controller => :setup, :action => :setup_security_key_manually
    end
    flash[:notice] = "Key file created successfully"
    redirect_to :controller => :setup, :action => :setup_encryption
  end

  # This method should attempt to load the key from a file.  If it can, it will make the user accept the key
  # with the understanding that this cannot be undone and that the database is forever locked
  def setup_encryption
    if securityKeyPresent?
      @key_file = securityVolumeDirectory + "security/secret.key"
      @attached_security_key = loadKeyFromFile
      @fingerprint = getFingerprintString(hex_str2array(@attached_security_key))
    else
      redirect_to :controller => :setup, :action => :setup_security_key
      return
    end
    render :layout => "security_error"
  end
  
  def accept_encryption
    if Setting.get("key_fingerprint")
      flash[:error] = "Database already keyed for a different fingerprint (#{params[:fingerprint]}}"
      redirect_to :back
      return
    end

    fingerprint = params[:fingerprint]

    unless fingerprint =~ /^[A-Fa-f0-9]{8}$/
      flash[:error] = "Fingerprint was invalid"
      redirect_to :back
      return
    end

    unless securityKeyPresent? && getFingerprintString(hex_str2array(loadKeyFromFile))==fingerprint
      flash[:error] = "Fingerprint did not match security key file currently attached to this server."
      redirect_to :back
      return
    end

    Setting.set("key_fingerprint", fingerprint);
    redirect_to :controller=>:setup, :action=>:encrypt_all
  end
  
  def encrypt_all
    Patient.find(:all).each{|a| a.save!}
    Visit.find(:all).each{|a| a.save!}
    Attending.find(:all).each{|a| a.save!}
#    User.find(:all).each{|a| puts a.first_name; a.save!}
    TbTest.find(:all).each{|a| a.save!}
    Prescription.find(:all).each{|a| a.save!}
    
    flash[:notice] = "Database encrypted"
    
    redirect_to :controller =>'home', :action => 'index'
  end
  
  def setup_admin_password
    if Setting.get("admin_password")
      flash[:error] = "Admin password is already set"
      redirect_to :back and return
    end
    render :layout => "security_error"
  end
  
  def accept_admin_password
     if Setting.get("admin_password")
      flash[:error] = "Admin password is already set"
      redirect_to :back and return
    end
    
    pass1 = params[:admin][:new_pass_1]
    pass2 = params[:admin][:new_pass_2]
    
    unless pass1==pass2
      flash[:error] = "Passwords do not match."
      redirect_to :back and return
    end
    
    unless pass1 =~ /^\w{8,16}$/
      flash[:error] = "Password must be between 8 and 16 alpha-numeric characters"
      redirect_to :back and return
    end
    
    Setting.set("admin_password", hash_password(pass1))
    flash[:notice] = "Administrator password set."
    
    redirect_to :controller=>:home, :action=>:index
  end
  
  def setup_first_user
    unless User.find(:all).select{|u| u.access_hash && u.access_hash!=""}.empty?
      flash[:error] = "First user is already set"
      redirect_to :controller => :home, :action => :index and return
    end
    render :layout => "security_error"
  end
  
  def add_first_user
    unless User.find(:all).select{|u| u.access_hash && u.access_hash!=""}.empty?
      flash[:error] = "First user is already set"
      redirect_to :controller => :home, :action => :index and return
    end
    
    ac1 = params[:access_code][:ac1]
    ac2 = params[:access_code][:ac2]
    
    unless ac1==ac2
      flash[:error] = "Access codes do not match"
      redirect_to :back
      return
    end
    
    unless /\A[a-zA-Z0-9]{4}\Z/ =~ ac1 && /\A[a-zA-Z0-9]{4}\Z/ =~ ac2
      flash[:error] = "Access codes must be four alpha-numeric characters long"
      redirect_to :back
      return
    end
    
    user = User.new(params[:user])
    user.access_hash = User.hash_access_code(ac1)
    user.can_be_admin = true
    
    if user.save
      flash[:notice] = "User #{user.to_label} created."
    else
      flash[:error] = "Could not save user."
    end
    
    redirect_to :controller => :home, :action => :index
  end
  
  def security_error
    reset_session
    render :layout => "security_error"
  end
  
  def incompatible_browser
    @browser_name = params[:browser_name] || 'unknown'
    render :layout => 'security_error'
  end
  
  def ignore_incompatible_browser
    session[:ignore_incompatible_browser] = true;
    
    flash[:warning] = "Be aware that the browser you are using is incomplatible with ClinicDB."
    
    redirect_to :controller => :home, :action => :index
  end
end