require 'find'

def get_svn_revision
  $current_revision = $current_revision || load_svn_revision
end

def get_db_revision
  sql = ActiveRecord::Base.connection()
  sql.execute("SELECT version FROM schema_migrations").collect{|a| a['version'].to_i}.max
end

def browser_name(request)
    ua = request.env['HTTP_USER_AGENT'].downcase
      
    if ua.index('msie') && !ua.index('opera') && !ua.index('webtv')
      'ie'+ua[ua.index('msie')+5].chr
    elsif ua.index('gecko/')
      'gecko'
    elsif ua.index('opera')
      'opera'
    elsif ua.index('konqueror')
      'konqueror'
    elsif ua.index('applewebkit/')
      'safari'
    elsif ua.index('mozilla/')
      'gecko'
    end
  end

private

def load_svn_revision
  rev_lines = `svn info -R #{Rails.root}/ | grep Revision`
  max = 0
  rev_lines.each_line { |line| 
    rev_str = line.split(":")[1].strip
    max = [max, rev_str.to_i].max if rev_str =~ /\d{1,}/
  }
  puts "Loaded SVN revision ##{max}"
  max
end