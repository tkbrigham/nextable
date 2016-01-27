require 'test_helper'
require 'nextable_test'

module ParamTests
  class CycleTest < NextableTest
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
end
