class Resource < ApplicationRecord

  belongs_to :user

  validates_presence_of :name, :quantity, :points

  def total_points
    quantity * points
  end
end
