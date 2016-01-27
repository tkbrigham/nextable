# This module adds records that allow sane comparisons of values, mostly in the
# realm of downcasing string fields.

module Nextable::DB
  ####
  ## next_record methods
  ####

  def db_field_is_nil_next_record
    if self.send(@field).nil?
      db_next_nil || db_first_non_nil
    end
  end

  def db_equal_field_with_greater_id
    @scope.where(db_eq_field_greater_id_params).order(:id).first
  end

  def db_with_greater_field
    @scope.where(db_greater_query, db_param).
      order(by_field).order(:id).first
  end

  def db_first_of_field
    return nil unless @cycle
    @scope.order(by_field).order(:id).first
  end

  ####
  ## previous_record methods
  ####

  def db_field_is_nil_prev_record
    if self.send(@field).nil?
      db_prev_nil || db_last_non_nil
    end
  end

  def db_equal_field_with_lesser_id
    @scope.where(db_eq_field_lesser_id_params).order(id: :desc).first
  end

  def db_with_lesser_field
    @scope.where(db_lesser_query, db_param).
      order(by_field_desc).order(id: :desc).first ||
      @scope.where("#{@field} IS NULL").order(id: :desc).first
  end

  def db_last_of_field
    return nil unless @cycle
    @scope.order(by_field_desc).order(id: :desc).first
  end

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
