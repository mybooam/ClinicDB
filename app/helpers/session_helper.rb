module SessionHelper
  def lastSession
    Session.find(:all).sort{|a, b| a.session_date <=> b.session_date}.last()
  end
end
