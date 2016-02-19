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
      with_greater_field || (first_of_field if @cycle)
  end

  def field_is_nil_next_record
    if self.send(@field).nil?
      db_next_nil || db_first_non_nil
    end
  end

  def equal_field_with_greater_id
    @scope.where(db_eq_field_greater_id_params).order(:id).first
  end

  def with_greater_field
    @scope.where(db_greater_query, db_param).
      order(by_field).order(:id).first
  end

  def first_of_field
    @scope.order(by_field).order(:id).first
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
      with_lesser_field || (last_of_field if @cycle)
  end

  def field_is_nil_prev_record
    if self.send(@field).nil?
      db_prev_nil || db_last_non_nil
    end
  end

  def equal_field_with_lesser_id
    @scope.where(db_eq_field_lesser_id_params).order(id: :desc).first
  end

  def with_lesser_field
    @scope.where(db_lesser_query, db_param).
      order(by_field_desc).order(id: :desc).first ||
      @scope.where("#{@field} IS NULL").order(id: :desc).first
  end

  def last_of_field
    @scope.order(by_field_desc).order(id: :desc).first
  end
end

ActiveRecord::Base.send :include, Nextable
