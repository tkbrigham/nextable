# This module adds records that allow sane comparisons of values, mostly in the
# realm of downcasing string fields.

module Nextable::DB
  private

  ####
  ## next_record helpers
  ####

  def db_next_nil
    @scope.where("#{@field} IS NULL AND id > ?", id).order(:id).first
  end

  def db_first_non_nil
    @scope.where("#{@field} IS NOT NULL").order(by_field).first
  end

  def by_field
    return "lower(#{@field}) asc" if field_is_string?
    "#{@field} asc"
  end

  def db_eq_field_greater_id_params
    return db_eq_field_next_record, db_param, id
  end

  def db_eq_field_next_record
    return "lower(#{@field}) = ? AND id > ?" if field_is_string?
    "#{@field} = ? AND id > ?"
  end

  def db_greater_query
    return "lower(#{@field}) > ?" if field_is_string?
    "#{@field} > ?"
  end

  ####
  ## previous_record helpers
  ####

  def db_prev_nil
    @scope.where("#{@field} IS NULL AND id < ?", id).order(id: :desc).first
  end

  def db_last_non_nil
    @scope.where("#{@field} IS NOT NULL").order(by_field_desc).first
  end

  def by_field_desc
    return "lower(#{@field}) desc" if field_is_string?
    "#{@field} desc"
  end

  def db_eq_field_lesser_id_params
    return db_eq_field_previous_record, db_param, id
  end

  def db_eq_field_previous_record
    return "lower(#{@field}) = ? AND id < ?" if field_is_string?
    "#{@field} = ? AND id < ?"
  end

  def db_lesser_query
    return "lower(#{@field}) < ?" if field_is_string?
    "#{@field} < ?"
  end

  ### Utility ###
  def db_param
    input = self.send(@field)
    input.tap { |i| i.downcase! if field_is_string? }
  end

  def field_is_string?
    self.class.columns_hash[@field].type == :string
  end

  def field_is_date_or_time?
    self.class.columns_hash[@field].type == :string
  end
end
