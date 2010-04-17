require 'find'

def get_local_svn_revision
  $current_local_revision = $current_local_revision || load_local_svn_revision
end

def get_head_svn_revision
  $current_head_revision = $current_head_revision || load_head_svn_revision
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

def load_local_svn_revision
  rev_lines = `svn info -R #{Rails.root}/ | grep Revision`
  max = 0
  rev_lines.each_line { |line| 
    rev_str = line.split(":")[1].strip
    max = [max, rev_str.to_i].max if rev_str =~ /\d{1,}/
  }
  puts "Found local SVN revision ##{max}"
  max
end

def load_head_svn_revision
  rev = "unknown"
  begin
    rev_lines = `svn log #{Rails.root}/ -r HEAD`
    rev_lines = rev_lines.select{|line| line =~ /\Ar\d{1,}/}
    puts rev_lines.join "|"
    rev = "unknown"
    if rev_lines.size > 0
      rev = rev_lines[0].split("|")[0].strip
      rev = rev[1..rev.length-1]
    end
  rescue
  end
  puts "Found HEAD SVN revision ##{rev}"
  rev
end