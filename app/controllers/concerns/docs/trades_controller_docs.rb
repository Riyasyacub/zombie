module Docs::TradesControllerDocs
  extend ActiveSupport::Concern
  class_methods do

    def create_trade
      return example <<-EOS
    POST /api/trades    
    payload
    {
      "from": {
        "id": "7444f7d9-c774-4afa-81b9-e1b7e8e8c131",
        "items": [
          { "name": "Fiji Water", "quantity": 2 },
          { "name": "AK47", "quantity": 1 }
        ]
      },
      "to": {
        "id": "8f815f18-a575-4434-a15e-70a471b8128c",
        "items": [
          { "name": "Campbell Soup", "quantity": 3 },
          { "name": "First Aid Pouch", "quantity": 4 }
        ]
      }
    }
    200
    {
      "message": "Trade Successful"
    }
    404
    {
      "message": "From user not found"
    }
    404
    {
      "message": "To user not found"
    }
    422
    {
      "message": "Infected user cannot perform trade"
    }
    422
    {
      "errors": [
        "from user does not contain 2 units of Fiji Waters",
        "to user does not contain 4 units of First Aid Pouches"
      ]
    }
    422
    {
      "errors": [
        "Trade items must be present for from user",
        "Trade items must be present for to user"
      ]
    }
    422
    {
      "message": "Points of items of both users must be equal to trade"
    }
      EOS
    end

  end
end