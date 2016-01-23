# Allows "walking" of a table of ActiveRecord records by implementing
# #next_record and #previous_record.
#
# Options:
# - field: [Defaults to 'id'] which field should be used to calculate order. If
#   two records have the same value for the specified field, records will be
#   sub-ordered by ID.
# - cycle: [Defaults to false] upon reaching last (or first) record in order,
#   determines whether or not it should return nil or cycle to beginning (or end)
# - filters: [Defaults to {}] a hash passed to self.class.where to determine
#   scope. This will break if the ActiveRecord object does not have all of the
#   keys that are passed into the hash.

require 'nextable/db'

module Nextable
  include Nextable::DB

  def next_record(opts = {})
    initialize!(opts)
    return pick_next_record if @field == 'id'
    pick_next_record_for_field
  end

  def previous_record(opts = {})
    initialize!(opts)
    return pick_previous_record if @field == 'id'
    pick_previous_record_for_field
  end

  private

  def initialize!(options)
    @field = options.fetch(:field, 'id')
    @cycle = options.fetch(:cycle, false)
    @scope = self.class.where(options[:filters])
    options.tap do |opt|
      opt[:field] = @field
      opt[:cycle] = @cycle
      opt[:filters] = opt.fetch(:filters, {})
    end
  end

  ####
  ## next_record methods
  ####

  def pick_next_record
    @scope.where("id > ?", id).order(:id).first || 
      (@scope.order(:id).first if @cycle)
  end

  def pick_next_record_for_field
    field_is_nil_next_record || equal_field_with_greater_id || 
      with_greater_field || first_of_field
  end

  def field_is_nil_next_record
    db_field_is_nil_next_record
  end

  def equal_field_with_greater_id
    db_equal_field_with_greater_id
  end

  def with_greater_field
    db_with_greater_field
  end

  def first_of_field
    db_first_of_field
  end

  ####
  ## previous_record methods
  ####

  def pick_previous_record
    @scope.where("id < ?", id).order(id: :desc).first || 
      (@scope.order(id: :desc).first if @cycle)
  end

  def pick_previous_record_for_field
    field_is_nil_prev_record || equal_field_with_lesser_id || 
      with_lesser_field || last_of_field
  end

  def field_is_nil_prev_record
    db_field_is_nil_prev_record
  end

  def equal_field_with_lesser_id
    db_equal_field_with_lesser_id
  end

  def with_lesser_field
    db_with_lesser_field
  end

  def last_of_field
    db_last_of_field
  end
end

ActiveRecord::Base.send :include, Nextable
