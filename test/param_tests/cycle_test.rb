require 'test_helper'
require 'nextable_test'

module ParamTests
  class CycleTest < NextableTest
    class NextRecord < CycleTest
      test "default will cycle by id" do
        @first, @second, @third = create_three_users
        assert_equal @third.next_record(cycle: true), @first
      end

      test "date field" do
        @feb_1965, @feb_1942, @jan_1929 = create_three_users
        jan =  @feb_1965.next_record(field: 'date_of_birth', cycle: true)
        assert_equal jan, @jan_1929
      end

      test "integer field" do
        @six, @eight, @seven = create_three_users
        six = @eight.next_record(cycle: true, field: 'total_friends')
        assert_equal six, @six
      end

      test "string field" do
        @malcolm, @huey, @mlk = create_three_users
        assert_equal @mlk.next_record(cycle: true, field: 'name'), @huey
      end
    end

    class PreviousRecord < CycleTest
      test "default will cycle by id" do
        @first, @second, @third = create_three_users
        assert_equal @first.previous_record(cycle: true), @third
      end

      test "date field" do
        @feb_1965, @feb_1942, @jan_1929 = create_three_users
        feb = @jan_1929.previous_record(field: 'date_of_birth', cycle: true)
        assert_equal feb, @feb_1965
      end

      test "integer field" do
        @six, @eight, @seven = create_three_users
        eight = @six.previous_record(cycle: true, field: 'total_friends')
        assert_equal eight, @eight
      end

      test "string field" do
        @malcolm, @huey, @mlk = create_three_users
        assert_equal @huey.previous_record(cycle: true, field: 'name'), @mlk
      end
    end
  end
end
