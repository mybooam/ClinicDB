require 'find'

def get_svn_revision
  $current_revision = $current_revision || load_svn_revision
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