require 'test_helper'
require 'nextable_test'

module ParamTests
  class FiltersTest < NextableTest
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
end
