# This module adds records that allow sane comparisons of values, mostly in the
# realm of downcasing string fields.

module Nextable
  module DB
    private

    ####
    ## next_record helpers
    ####

    def next_nil
      @scope.where("? IS NULL AND id > ?", @field, id).order(:id).first
    end

    def first_non_nil
      @scope.where("? IS NOT NULL", @field)
    end

    def greater_id_params
      if field_is_string?
        ["? = ? AND id > ?", @field.downcase, self.send(@field).downcase, id]
      else
        ["#{@field} = ? AND id > ?", self.send(@field), id]
      end
    end

    def greater_field_params
      if field_is_string?
        ["lower(#{@field}) > ?", self.send(@field).downcase]
      else
        ["#{@field} > ?", self.send(@field)]
      end
    end

    ####
    ## previous_record helpers
    ####

    def prev_nil
      @scope.where("? IS NULL AND id < ?", id).order(id: :desc).first
    end

    def last_non_nil
      @scope.where("? IS NOT NULL")
    end

    def lesser_id_params
      if field_is_string?
        ["lower(#{@field}) = ? AND id < ?", self.send(@field).downcase, id]
      else
        ["#{@field} = ? AND id < ?", self.send(@field), id]
      end
    end

    def lesser_field_params
      if field_is_string?
        ["lower(#{@field}) < ?", self.send(@field).downcase]
      else
        ["#{@field} < ?", self.send(@field)]
      end
    end

    ### Utility ###
    def field_is_string?
      self.class.columns_hash[@field].type == :string
    end
  end
end
