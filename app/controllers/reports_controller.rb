class ReportsController < ApplicationController
  include Docs::ReportsControllerDocs

  def_param_group :reports do
    param :infected_survivors_rate, Float, required: true
    param :non_infected_survivors_rate, Float, required: true
    param :averages, Array, required: true
    param :points_lost, Float, required: true
  end

  api :GET, '/reports', "Report Details"
  error code: 500, desc: 'Internal Server Error'
  returns :reports, code: 200, desc: "Report Details"
  reports_index

  def index
    @infected_survivors = (User.infected.count / User.all.count.to_f)
    @average_items      = average_items
    @points_lost        = points_lost
  end

  private

  def average_items
    base_scope        = User.joins('left join resources on resources.user_id = users.id')
                            .group('resources.name')
                            .select('resources.name, sum(resources.quantity) / (select count(*) from users) average')
    resource_with_avg = User.from(base_scope, :users).pluck('name', 'average').to_h

    Zombie::RESOURCES.values.pluck('name').map do |item_name|
      [item_name, resource_with_avg[item_name].to_f]
    end.to_h
  end

  def points_lost
    infected_resources = User.infected
                             .joins(:resources)
                             .group('resources.name')
                             .sum('resources.quantity')
    Zombie::RESOURCES.values.map do |item|
      (infected_resources[item['name']] || 0) * item['points']
    end.sum
  end
end
