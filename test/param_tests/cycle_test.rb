require 'test_helper'
require 'nextable_test'

module ParamTests
  class CycleTest < NextableTest
    setup do
      @@first, @@second, @@third = create_three_users

      # Aliased for easier reading of individual tests
      @@feb_1965 = @@six = @@malcolm = @@first
      @@feb_1942 = @@eight = @@huey = @@second
      @@jan_1929 = @@seven = @@mlk = @@third
    end

    class NextRecord < CycleTest
      test "default will cycle by id" do
        assert_equal @@third.next_record(cycle: true), @@first
      end

      test "date field" do
        jan =  @@feb_1965.next_record(cycle: true, field: 'date_of_birth')
        assert_equal jan, @@jan_1929
      end

      test "integer field" do
        six = @@eight.next_record(cycle: true, field: 'total_friends')
        assert_equal six, @@six
      end

      test "string field" do
        assert_equal @@mlk.next_record(cycle: true, field: 'name'), @@huey
      end
    end

    class PreviousRecord < CycleTest
      test "default will cycle by id" do
        assert_equal @@first.previous_record(cycle: true), @@third
      end

      test "date field" do
        feb = @@jan_1929.previous_record(cycle: true, field: 'date_of_birth')
        assert_equal feb, @@feb_1965
      end

      test "integer field" do
        eight = @@six.previous_record(cycle: true, field: 'total_friends')
        assert_equal eight, @@eight
      end

      test "string field" do
        assert_equal @@huey.previous_record(cycle: true, field: 'name'), @@mlk
      end
    end
  end
end
