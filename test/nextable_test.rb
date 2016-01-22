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
    test "datetime_field_example_birthday" do
      @feb_1965, @feb_1942, @jan_1929 = create_three_users

      # next_record
      assert_equal @jan_1929.next_record(field: 'birthday'), @feb_1942
      assert_equal @feb_1942.next_record(field: 'birthday'), @feb_1965

      # previous_record
      assert_equal @feb_1965.previous_record(field: 'birthday'), @feb_1942
      assert_equal @feb_1942.previous_record(field: 'birthday'), @jan_1929

      # final record of each direction
      assert_equal @jan_1929.previous_record(field: 'birthday'), nil
      assert_equal @feb_1965.next_record(field: 'birthday'), nil
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

    test "cycle_by_datetime_field_example_birthday" do
      @feb_1965, @feb_1942, @jan_1929 = create_three_users

      # final record of each direction
      assert_equal @jan_1929.previous_record(
        field: 'birthday', cycle: true), @feb_1965
      assert_equal @feb_1965.next_record(
        field: 'birthday', cycle: true), @jan_1929
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
  end

  private

  def create_three_users
    first = User.create!(name: 'Malcom Little', total_friends: 6, birthday: 'February 21, 1965')
    second = User.create!(name: 'Huey Newton', total_friends: 8, birthday: 'February 17, 1942')
    third = User.create!(name: 'MLK Junior', total_friends: 7, birthday: 'January 15, 1929')
    return first, second, third
  end
end
