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

  class WithFieldParam < NextableTest
    test "date_field_example_date_of_birth" do
      @feb_1965, @feb_1942, @jan_1929 = create_three_users

      # next_record
      assert_equal @jan_1929.next_record(field: 'date_of_birth'), @feb_1942
      assert_equal @feb_1942.next_record(field: 'date_of_birth'), @feb_1965

      # previous_record
      assert_equal @feb_1965.previous_record(field: 'date_of_birth'), @feb_1942
      assert_equal @feb_1942.previous_record(field: 'date_of_birth'), @jan_1929

      # final record of each direction
      assert_equal @jan_1929.previous_record(field: 'date_of_birth'), nil
      assert_equal @feb_1965.next_record(field: 'date_of_birth'), nil
    end

    test "time_field_example_time_of_birth" do
      @ten_am, @nine_am, @eleven_am = create_three_users

      # next_record
      assert_equal @nine_am.next_record(field: 'time_of_birth'), @ten_am
      assert_equal @ten_am.next_record(field: 'time_of_birth'), @eleven_am

      # previous_record
      assert_equal @eleven_am.previous_record(field: 'time_of_birth'), @ten_am
      assert_equal @ten_am.previous_record(field: 'time_of_birth'), @nine_am

      # final record of each direction
      assert_equal @nine_am.previous_record(field: 'time_of_birth'), nil
      assert_equal @eleven_am.next_record(field: 'time_of_birth'), nil
    end

    test "integer_field_example_total_friends" do
      @six, @eight, @seven = create_three_users

      # next_record
      assert_equal @six.next_record(field: 'total_friends'), @seven
      assert_equal @seven.next_record(field: 'total_friends'), @eight

      # previous_record
      assert_equal @eight.previous_record(field: 'total_friends'), @seven
      assert_equal @seven.previous_record(field: 'total_friends'), @six

      # final record of each direction
      assert_equal @six.previous_record(field: 'total_friends'), nil
      assert_equal @eight.next_record(field: 'total_friends'), nil
    end

    test "string_field_example_name" do
      @malcolm, @huey, @mlk = create_three_users

      # next_record
      assert_equal @huey.next_record(field: 'name'), @malcolm
      assert_equal @malcolm.next_record(field: 'name'), @mlk

      # previous_record
      assert_equal @mlk.previous_record(field: 'name'), @malcolm
      assert_equal @malcolm.previous_record(field: 'name'), @huey

      # final record of each direction
      assert_equal @huey.previous_record(field: 'name'), nil
      assert_equal @mlk.next_record(field: 'name'), nil
    end
  end

  class WithCycleTrue < NextableTest
    test "default_will_cycle_by_id" do
      @first, @second, @third = create_three_users

      # final record of each direction
      assert_equal @first.previous_record(cycle: true), @third
      assert_equal @third.next_record(cycle: true), @first
    end

    test "cycle_by_date_field_example_date_of_birth" do
      @feb_1965, @feb_1942, @jan_1929 = create_three_users

      # final record of each direction
      assert_equal @jan_1929.previous_record(
        field: 'date_of_birth', cycle: true), @feb_1965
      assert_equal @feb_1965.next_record(
        field: 'date_of_birth', cycle: true), @jan_1929
    end

    test "cycle_by_integer_field_example_total_friends" do
      @six, @eight, @seven = create_three_users

      # final record of each direction
      assert_equal @six.previous_record(
        cycle: true, field: 'total_friends'), @eight
      assert_equal @eight.next_record(
        cycle: true, field: 'total_friends'), @six
    end

    test "cycle_by_string_field_example_name" do
      @malcolm, @huey, @mlk = create_three_users

      # final record of each direction
      assert_equal @mlk.next_record(cycle: true, field: 'name'), @huey
      assert_equal @huey.previous_record(cycle: true, field: 'name'), @mlk
    end
  end

  class WithFiltersParam < NextableTest
    setup do
      @first, @second, @third, @fourth, @fifth, @sixth, @seventh = create_seven_users
    end

    test "with_jun_2_1991_date_of_birth" do
      assert_equal @second.next_record(filters: { date_of_birth: '1991-06-02' }), @third
      assert_equal @fifth.next_record(filters: { date_of_birth: '1991-06-02' }), nil
    end

    test "with_oct_26_1990_date_of_birth" do
      assert_equal @second.next_record(filters: { date_of_birth: '1990-10-26' }), @fifth
      assert_equal @fifth.next_record(filters: { date_of_birth: '1990-10-26' }), @sixth

      assert_equal @sixth.previous_record(filters: { date_of_birth: '1990-10-26' }), @fifth
      assert_equal @fifth.previous_record(filters: { date_of_birth: '1990-10-26' }), nil

      # with cycle
      assert_equal @fifth.previous_record(cycle: true, filters: { date_of_birth: '1990-10-26' }), @seventh
      assert_equal @seventh.next_record(cycle: true, filters: { date_of_birth: '1990-10-26' }), @fifth

      # with field param
      assert_equal @fifth.previous_record(field: 'name', filters: { date_of_birth: '1990-10-26' }), @sixth
      assert_equal @seventh.next_record(field: 'name', filters: { date_of_birth: '1990-10-26' }), @sixth
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
