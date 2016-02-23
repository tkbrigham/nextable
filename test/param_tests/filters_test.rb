require 'test_helper'
require 'nextable_test'

module ParamTests
  class FiltersTest < NextableTest
    setup do
      @@first, @@second, @@third, @@fourth, @@fifth, @@sixth, @@seventh = create_seven_users
      @@june_opts = { filters: { date_of_birth: '1991-06-02' } }
      @@oct_opts = { filters: { date_of_birth: '1990-10-26' } }
    end

    class NextRecord < FiltersTest
      class DateFilter < NextRecord
        test "default" do
          assert_equal @@second.next_record(@@june_opts), @@third
          assert_equal @@fifth.next_record(@@june_opts), nil
        end

        test "with cycle" do
          fifth = @@seventh.next_record(@@oct_opts.merge(cycle: true))
          assert_equal fifth, @@fifth
        end

        test "with field" do
          sixth = @@seventh.next_record(@@oct_opts.merge(field: 'name'))
          assert_equal sixth, @@sixth
        end
      end

      class IntegerFilter < NextRecord
        test "default" do
          skip
        end

        test "with cycle" do
          skip
        end

        test "with field" do
          skip
        end
      end

      class StringFilter < NextRecord
        test "default" do
          skip
        end

        test "with cycle" do
          skip
        end

        test "with field" do
          skip
        end
      end
    end

    class PreviousRecord < FiltersTest
      class DateFilter < PreviousRecord
        test "default" do
          assert_equal @@second.previous_record(@@june_opts), @@first
          assert_equal @@first.previous_record(@@june_opts), nil
        end

        test "with cycle" do
          seventh = @@fifth.previous_record(@@oct_opts.merge(cycle: true))
          assert_equal seventh, @@seventh
        end

        test "with field" do
          sixth = @@fifth.previous_record(@@oct_opts.merge(field: 'name'))
          assert_equal sixth, @@sixth
        end
      end

      class IntegerFilter < PreviousRecord
        test "default" do
          skip
        end

        test "with cycle" do
          skip
        end

        test "with field" do
          skip
        end
      end

      class StringFilter < PreviousRecord
        test "default" do
          skip
        end

        test "with cycle" do
          skip
        end

        test "with field" do
          skip
        end
      end
    end
  end
end
