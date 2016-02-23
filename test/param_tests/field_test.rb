require 'test_helper'
require 'nextable_test'

module ParamTests
  class FieldTest < NextableTest
    ####
    ## Next Record
    ####

    class NextRecord < FieldTest
      class WithDateField < NextRecord
        test "defaults" do
          @feb_1965, @feb_1942, @jan_1929 = create_three_users
          assert_equal @jan_1929.next_record(field: 'date_of_birth'), @feb_1942
          assert_equal @feb_1942.next_record(field: 'date_of_birth'), @feb_1965
        end

        test "last record returns nil" do
          @feb_1965, @feb_1942, @jan_1929 = create_three_users
          assert_equal @feb_1965.next_record(field: 'date_of_birth'), nil
        end
      end

      class WithTimeField < NextRecord
        test "defaults" do
          @ten_am, @nine_am, @eleven_am = create_three_users
          assert_equal @nine_am.next_record(field: 'time_of_birth'), @ten_am
          assert_equal @ten_am.next_record(field: 'time_of_birth'), @eleven_am
        end

        test "last record returns nil" do
          @ten_am, @nine_am, @eleven_am = create_three_users
          assert_equal @eleven_am.next_record(field: 'time_of_birth'), nil
        end
      end

      class WithIntegerField < NextRecord
        test "defaults" do
          @six, @eight, @seven = create_three_users
          assert_equal @six.next_record(field: 'total_friends'), @seven
          assert_equal @seven.next_record(field: 'total_friends'), @eight
        end

        test "last record returns nil" do
          @six, @eight, @seven = create_three_users
          assert_equal @eight.next_record(field: 'total_friends'), nil
        end
      end

      class WithStringField < NextRecord
        test "defaults" do
          @malcolm, @huey, @mlk = create_three_users
          assert_equal @huey.next_record(field: 'name'), @malcolm
          assert_equal @malcolm.next_record(field: 'name'), @mlk
        end

        test "last record returns nil" do
          @malcolm, @huey, @mlk = create_three_users
          assert_equal @mlk.next_record(field: 'name'), nil
        end
      end
    end

    ####
    ## Previous Record
    ####

    class PreviousRecord < FieldTest
      class WithDateField < PreviousRecord
        test "defaults" do
          @feb_1965, @feb_1942, @jan_1929 = create_three_users
          assert_equal @feb_1965.previous_record(field: 'date_of_birth'), @feb_1942
          assert_equal @feb_1942.previous_record(field: 'date_of_birth'), @jan_1929
        end

        test "last record returns nil" do
          @feb_1965, @feb_1942, @jan_1929 = create_three_users
          assert_equal @jan_1929.previous_record(field: 'date_of_birth'), nil
        end
      end

      class WithTimeField < PreviousRecord
        test "defaults" do
          @ten_am, @nine_am, @eleven_am = create_three_users
          assert_equal @eleven_am.previous_record(field: 'time_of_birth'), @ten_am
          assert_equal @ten_am.previous_record(field: 'time_of_birth'), @nine_am
        end

        test "last record returns nil" do
          @ten_am, @nine_am, @eleven_am = create_three_users
          assert_equal @nine_am.previous_record(field: 'time_of_birth'), nil
        end
      end

      class WithIntegerField < PreviousRecord
        test "defaults" do
          @six, @eight, @seven = create_three_users
          assert_equal @eight.previous_record(field: 'total_friends'), @seven
          assert_equal @seven.previous_record(field: 'total_friends'), @six
        end

        test "last record returns nil" do
          @six, @eight, @seven = create_three_users
          assert_equal @six.previous_record(field: 'total_friends'), nil
        end
      end

      class WithStringField < PreviousRecord
        test "defaults" do
          @malcolm, @huey, @mlk = create_three_users
          assert_equal @mlk.previous_record(field: 'name'), @malcolm
          assert_equal @malcolm.previous_record(field: 'name'), @huey
        end

        test "last record returns nil" do
          @malcolm, @huey, @mlk = create_three_users
          assert_equal @huey.previous_record(field: 'name'), nil
        end
      end
    end
  end
end
