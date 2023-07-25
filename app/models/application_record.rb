class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  normalize_blank_values
end
