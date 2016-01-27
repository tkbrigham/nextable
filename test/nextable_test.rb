require 'test_helper'

class NextableTest < ActiveSupport::TestCase
  class Defaults < NextableTest
    setup do
      @first, @second, @third = create_three_users
    end

    test "next_record_fetches_user_with_ascending_id" do
      assert_equal @first.next_record, @second
      assert_equal @second.next_record, @third
    end

    test "previous_record_fetches_user_with_descending_id" do
      assert_equal @second.previous_record, @first
      assert_equal @third.previous_record, @second
    end

    test "last_user_next_record_returns_nil" do
      assert_equal @third.next_record, nil
    end

    test "first_user_previous_record_returns_nil" do
      assert_equal @first.previous_record, nil
    end
  end

  private

  def create_seven_users
    first = User.create!(name: 'Gibbert', total_friends: 1, date_of_birth: 'June 2, 1991')
    second = User.create!(name: 'Fubart', total_friends: 1, date_of_birth: 'June 2, 1991')
    third = User.create!(name: 'Ebert', total_friends: 1, date_of_birth: 'June 2, 1991')
    fourth = User.create!(name: 'Dilbert', total_friends: 2, date_of_birth: 'June 2, 1991')
    fifth = User.create!(name: 'Cubert', total_friends: 2, date_of_birth: 'October 26, 1990')
    sixth = User.create!(name: 'Bertal', total_friends: 3, date_of_birth: 'October 26, 1990')
    seventh = User.create!(name: 'Albert', total_friends: 3, date_of_birth: 'October 26, 1990')
    return first, second, third, fourth, fifth, sixth, seventh
  end

  def create_three_users
    first = User.create!(name: 'Malcom Little',
                         total_friends: 6,
                         date_of_birth: 'February 21, 1965',
                         time_of_birth: '10:00am')
    second = User.create!(name: 'Huey Newton',
                          total_friends: 8,
                          date_of_birth: 'February 17, 1942',
                          time_of_birth: '9:00am')
    third = User.create!(name: 'MLK Junior',
                         total_friends: 7,
                         date_of_birth: 'January 15, 1929',
                         time_of_birth: '11:00am')
    return first, second, third
  end
end
