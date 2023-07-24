module NormalizeBlankValues
  extend ActiveSupport::Concern

  def normalize_blank_values
    attributes.each do |column, value|
      self[column].present? || self[column] = nil unless value == false
    end
  end

  module ClassMethods
    def normalize_blank_values
      before_save :normalize_blank_values
    end
  end
end

ActiveRecord::Base.send(:include, NormalizeBlankValues)
