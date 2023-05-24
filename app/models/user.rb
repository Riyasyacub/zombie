class User < ApplicationRecord
  attr_accessor :items

  has_many :resources, dependent: :destroy

  validates_presence_of :name, :age, :gender, :latitude, :longitude
  validates :gender, inclusion: { in: %w(male female transgender) }

  before_create :create_resources

  private

  def create_resources
    allowed_resources = Zombie::RESOURCES.values
    points            = allowed_resources.pluck('name', 'points').to_h
    items.each do |name, quantity|
      next unless name.in?(allowed_resources.pluck('name'))
      self.resources.new(name:     name,
                         quantity: quantity,
                         points:   points[name])
    end
  end
end
