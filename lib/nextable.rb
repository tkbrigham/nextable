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
    field_is_nil_next || field_not_nil_next
  end

  def field_is_nil_next
    if self.send(@field).nil?
      next_nil || first_non_nil.order(by_field).first
    end
  end

  def field_not_nil_next
    rel = greater_ids.presence || greater_fields.presence ||
      (first_of_field if @cycle).presence
    rel.order(:id).first unless rel.nil?
  end

  def greater_ids
    @scope.where(greater_id_params)
  end

  def greater_fields
    @scope.where(greater_field_params).order(by_field)
  end

  def first_of_field
    @scope.order(by_field)
  end

  ####
  ## previous_record methods
  ####

  def pick_previous_record
    @scope.where("id < ?", id).order(id: :desc).first ||
      (@scope.order(id: :desc).first if @cycle)
  end

  def pick_previous_record_for_field
    field_is_nil_prev || field_not_nil_prev
  end

  def field_is_nil_prev
    if self.send(@field).nil?
      prev_nil || last_non_nil.order(by_desc_field).first
    end
  end

  def field_not_nil_prev
    rel = lesser_ids.presence || lesser_fields.presence ||
      (last_of_field if @cycle).presence
    rel.order(id: :desc).first unless rel.nil?
  end

  def lesser_ids
    @scope.where(lesser_id_params)
  end

  def lesser_fields
    @scope.where(lesser_field_params).order(by_field_desc).presence ||
      @scope.where("? IS NULL", @field).presence
  end

  def last_of_field
    @scope.order(by_field_desc)
  end

  private

  ## Ordering helpers

  def by_field
    return "lower(#{@field}) asc" if field_is_string?
    "#{@field} asc"
  end

  def by_field_desc
    return "lower(#{@field}) desc" if field_is_string?
    "#{@field} desc"
  end
end

ActiveRecord::Base.send :include, Nextable
