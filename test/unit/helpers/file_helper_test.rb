require File.dirname(__FILE__) + '/../../test_helper'
require 'lib/file_helpers'

class SecurityHelperTest < ActionView::TestCase
  test "svn revision number" do
    assert_match(/\d{1,}/, get_svn_revision.to_s)
  end
end