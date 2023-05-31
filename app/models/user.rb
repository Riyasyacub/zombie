class User < ApplicationRecord
  attr_accessor :items

  has_many :resources, dependent: :destroy

  validates_presence_of :name, :age, :gender, :latitude, :longitude
  validates :gender, inclusion: { in: %w(male female transgender) }

  before_create :create_resources

  scope :infected, -> { where(infected: true) }
  scope :non_infected, -> { where(infected: false) }

  def alter_resource(add_items, remove_items)
    return if self.infected?

    remove_items.each do |item|
      resource = self.resources.find_by(name: item[:name])
      next if resource.blank?
      if resource.quantity > item[:quantity].to_f
        resource.update(quantity: resource.quantity - item[:quantity].to_f)
      elsif resource.quantity == item[:quantity].to_f
        resource.destroy
      end
    end

    add_items.each do |item|
      resource = self.resources.find_by(name: item[:name])
      if resource.blank?
        self.resources.create!(name: item[:name], quantity: item[:quantity])
      else
        resource.update(quantity: resource.quantity + item[:quantity])
      end
    end
  end

  private

  def create_resources
    allowed_resources = Zombie::RESOURCES.values
    points            = allowed_resources.pluck('name', 'points').to_h
    items.each do |name, quantity|
      next unless name.to_s.in?(allowed_resources.pluck('name'))
      self.resources.new(name:     name,
                         quantity: quantity)
    end
  end
end
