require 'test_helper'

class NextableTest < ActiveSupport::TestCase
  def test_user_next_record_fetches_user_with_ascending_id
    mlk = User.create!(name: 'ML King', total_friends: 99, birthday: 'January 15, 1929')
    mx = User.create!(name: 'Malcom Little', total_friends: 600, birthday: 'February 21, 1965')
    assert_equal mlk.next_record, mx
  end
end
