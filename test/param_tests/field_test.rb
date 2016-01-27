require 'test_helper'
require 'nextable_test'

module ParamTests
  class FieldTest < NextableTest
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
end
