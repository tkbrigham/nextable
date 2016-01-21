require 'test_helper'

class CoreExtTest < ActiveSupport::TestCase
  def test_next_record_returns_record_with_next_id
    assert_equal User.find(1).next_record, User.find(2)
  end
end
