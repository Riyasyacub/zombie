module Docs::UsersControllerDocs
  extend ActiveSupport::Concern
  class_methods do
    def users_index
      return example <<-EOS
        GET /api/users       
        200
        {
          "data": [
                    {
                      "id": "fcfd91d1-8878-4203-a344-820cf66ca7c4",
                      "name": "John",
                      "age": 23,
                      "gender": "male",
                      "latitude": 89.734644,
                      "longitude": 24.897623,
                      "infected": false  
                    },
                    {
                      "id": "fcfd91d1-8878-4203-a344-820cf66ca7c4",
                      "name": "Wick",
                      "age": 29,
                      "gender": "female",
                      "latitude": 22.734644,
                      "longitude": 12.897623,
                      "infected": true
                    }
                  ]
        }
      EOS
    end

    def user_show
      return example <<-EOS
        GET /api/users/:id 
        params
        {
          "id": "fcfd91d1-8878-4203-a344-820cf66ca7c4"
        }      
        200
        {
          "id": "fcfd91d1-8878-4203-a344-820cf66ca7c4",
          "name": "John",
          "age": 23,
          "gender": "male",
          "latitude": 89.734644,
          "longitude": 24.897623,
          "infected": false
        }
        404
        {
          "message": "User not found"
        }
      EOS
    end

    def user_create
      return example <<-EOS
        POST /api/users    
        payload
        {
          "name": "John",
          "age": 23,
          "gender": "male",
          "latitude": 89.734644,
          "longitude": 24.897623,
          "items": {
                      "AK47": 5,
                      "Fiji Water": 8 
                   }
        }
        200
        {
          "id": "fcfd91d1-8878-4203-a344-820cf66ca7c4",
          "name": "John",
          "age": 23,
          "gender": "male",
          "latitude": 89.734644,
          "longitude": 24.897623,
          "infected": false
        }
        404
        {
          "message": "User not found"
        }
        422
        {
          "name": "Name can't be blank",
          "age": "Age can't be blank",
          "gender": "Gender can't be blank",
          "latitude": "Latitude can't be blank",
          "longitude": "Longitude can't be blank",
        }
      EOS
    end

    def user_update
      return example <<-EOS
        PATCH /api/users/:id  
        params 
        {
          "id": "fcfd91d1-8878-4203-a344-820cf66ca7c4"
        } 
        payload
        {
          "longitude": 84.897623,
          "infected": true
        }
        200
        {
          "id": "fcfd91d1-8878-4203-a344-820cf66ca7c4",
          "name": "John",
          "age": 23,
          "gender": "male",
          "latitude": 89.734644,
          "longitude": 24.897623,
          "infected": true
        }
        422
        {
          "name": "Name can't be blank",
          "age": "Age can't be blank",
          "gender": "Gender can't be blank",
          "latitude": "Latitude can't be blank",
          "longitude": "Longitude can't be blank",
        }
      EOS
    end

    def user_destroy
      return example <<-EOS
        PATCH /api/users/:id  
        params 
        {
          "id": "fcfd91d1-8878-4203-a344-820cf66ca7c4"
        } 
        200
        {
          "message": "User deleted successfully"
        }
        404
        {
          "message": "User not found"
        }
      EOS
    end
  end
end