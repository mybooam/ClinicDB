require 'lib/security_helpers'

class SetupController < ApplicationController
  def setup_encryption
    rkey = OpenSSL::Cipher::Cipher.new("aes-256-cbc").random_key
    @suggest = hex_array2str(rkey)
    @suggest_fingerprint = getFingerprintString(rkey)
    render :layout => "security_error"
  end
  
  def encryption_key_fingerprint
    key = params[:key]
    if key =~ /^[A-Fa-f0-9]{64}$/
      @fp = getFingerprintString(hex_str2array(key))
      render :layout => 'none';
    else
      render :text => "Error!"
     end
  end
  
  def accept_encryption
    if Setting.get("key_fingerprint")
      flash[:error] = "Database already keyed for a different fingerprint (#{params[:fingerprint]}}"
      redirect_to :back
      return
    end
    fingerprint = params[:fingerprint]
    if fingerprint =~ /^[A-Fa-f0-9]{8}$/
      Setting.set("key_fingerprint", fingerprint);
    else
      flash[:error] = "Fingerprint was invalid"
      redirect_to :back
      return
    end
    redirect_to :controller=>:home, :action=>:index
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
    if !User.find(:all).empty?
      flash[:error] = "First user is already set"
      redirect_to :controller => :home, :action => :index and return
    end
    render :layout => "security_error"
  end
  
  def add_first_user
    if !User.find(:all).empty?
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
end