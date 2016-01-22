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
#
module Nextable
  def next_record(opts = {})
    initialize!(opts)
    pick_next_record
  end

  def previous_record(opts = {})
    initialize!(opts)
    pick_previous_record
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
    equal_field_with_greater_id || with_greater_field || first_of_field
  end

  def equal_field_with_greater_id
    return nil if @field == 'id'
    nil_if_blank(
      @scope.where("#{@field} = ? AND id > ?", self.send(@field), id).
      order('id asc').first
    )
  end

  def with_greater_field
    nil_if_blank(@scope.where("#{@field} > ?", self.send(@field)).
                 order("#{@field} asc").order('id asc').first)
  end

  def first_of_field
    return nil unless @cycle
    @scope.order("#{@field} asc").first
  end

  ####
  ## previous_record methods
  ####

  def pick_previous_record
    equal_field_with_lesser_id || with_lesser_field || last_of_field
  end

  def equal_field_with_lesser_id
    return nil if @field == 'id'
    nil_if_blank(
      @scope.where("#{@field} = ? AND id < ?", self.send(@field), id).
      order('id desc').first
    )
  end

  def with_lesser_field
    nil_if_blank(@scope.where("#{@field} < ?", self.public_send(@field)).
                 order("#{@field} desc").order('id desc').first)
  end

  def last_of_field
    return nil unless @cycle
    @scope.order("#{@field} desc").first
  end

  ####
  ## other
  ####

  def nil_if_blank(relation)
    relation.blank? ? nil : relation
  end
end

ActiveRecord::Base.send :include, Nextable
