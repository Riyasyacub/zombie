module Docs::ReportsControllerDocs
  extend ActiveSupport::Concern
  class_methods do

    def reports_index
      return example <<-EOS
        GET /api/reports
        200
        {
          "infected_users_rate": 56,
          "non_infected_users_rate": 44,
          "averages": {
            "Fiji Water": 4,
            "Campbell Soup": 2,
            "First Aid Pouch": 0,
            "AK47": 1
          },
          "points_lost": 345
        }
      EOS
    end
  end
end