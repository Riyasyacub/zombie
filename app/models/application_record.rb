class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  def errors_to_hash
    errors = self.errors.to_hash(true)
    errors.each do |key, value|
      errors[key] = value.first
    end
    errors || {}
  end
end
