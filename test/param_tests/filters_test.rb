require 'test_helper'
require 'nextable_test'

module ParamTests
  class FiltersTest < NextableTest
    setup do
      @@first, @@second, @@third, @@fourth, @@fifth, @@sixth, @@seventh = create_seven_users
      @@june_opts = { filters: { date_of_birth: '1991-06-02' } }
      @@int_opts = { filters: { total_friends: 1 } }
      @@str_opts = { filters: { name: 'Albert' } }
    end

    class NextRecord < FiltersTest
      class DateFilter < NextRecord
        test "date filter default" do
          assert_equal @@second.next_record(@@june_opts), @@third
          assert_equal @@fifth.next_record(@@june_opts), nil
        end

        test "date filter with cycle" do
          first = @@fourth.next_record(@@june_opts.merge(cycle: true))
          assert_equal first, @@first
        end

        test "date filter with field" do
          first = @@second.next_record(@@june_opts.merge(field: 'name'))
          assert_equal first, @@first
        end
      end

      class IntegerFilter < NextRecord
        test "integer filter default" do
          assert_equal @@third.next_record(@@int_opts), @@seventh
          assert_equal @@seventh.next_record(@@int_opts), nil
        end

        test "integer filter with cycle" do
          seventh = @@third.next_record(@@int_opts.merge(cycle: true))
          assert_equal seventh, @@seventh
        end

        test "integer filter with field" do
          first = @@second.next_record(@@int_opts.merge(field: 'name'))
          assert_equal first, @@first
        end
      end

      class StringFilter < NextRecord
        test "string filter default" do
          assert_equal @@sixth.next_record(@@str_opts), @@seventh
          assert_equal @@seventh.next_record(@@str_opts), nil
        end

        test "string filter with cycle" do
          fifth = @@seventh.next_record(@@str_opts.merge(cycle: true))
          assert_equal fifth, @@fifth
        end

        test "string filter with field" do
          fifth = @@sixth.next_record(@@str_opts.merge(field: 'total_friends'))
          assert_equal fifth, @@fifth
        end
      end
    end

    class PreviousRecord < FiltersTest
      class DateFilter < PreviousRecord
        test "date filter default" do
          assert_equal @@second.previous_record(@@june_opts), @@first
          assert_equal @@first.previous_record(@@june_opts), nil
        end

        test "date filter with cycle" do
          fourth = @@first.previous_record(@@june_opts.merge(cycle: true))
          assert_equal fourth, @@fourth
        end

        test "date filter with field" do
          fourth = @@third.previous_record(@@june_opts.merge(field: 'name'))
          assert_equal fourth, @@fourth
        end
      end

      class IntegerFilter < PreviousRecord
        test "integer filter default" do
          assert_equal @@third.previous_record(@@int_opts), @@second
          assert_equal @@first.previous_record(@@int_opts), nil
        end

        test "integer filter with cycle" do
          seventh = @@first.previous_record(@@int_opts.merge(cycle: true))
          assert_equal seventh, @@seventh
        end

        test "integer filter with field" do
          third = @@second.previous_record(@@int_opts.merge(field: 'name'))
          assert_equal third, @@third
        end
      end

      class StringFilter < PreviousRecord
        test "string filter default" do
          assert_equal @@sixth.previous_record(@@str_opts), @@fifth
          assert_equal @@fifth.previous_record(@@str_opts), nil
        end

        test "string filter with cycle" do
          seventh = @@fifth.previous_record(@@str_opts.merge(cycle: true))
          assert_equal seventh, @@seventh
        end

        test "string filter with field" do
          seventh = @@sixth.previous_record(@@str_opts.merge(field: 'total_friends'))
          assert_equal seventh, @@seventh
        end
      end
    end
  end
end
