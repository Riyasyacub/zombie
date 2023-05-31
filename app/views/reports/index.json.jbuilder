json.data do
  json.infected_survivors_rate @infected_survivors * 100
  json.non_infected_survivors_rate (1 - @infected_survivors) * 100
  json.averages do
    @average_items.each do |key, value|
      json.set! key, value
    end
  end
  json.points_lost @points_lost
end