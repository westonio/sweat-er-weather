# Sweat - Or - Sweater

## Project Overview
**Sweat-Or-Sweater** is a road trip planning application that provides users with the current weather and forecasted weather at their destination based on their estimated time of arrival - allowing users to better plan how they should pack/dress. This is a solo project I created focusing on service-oriented architecture, with this being the back-end service that aggregates data consumed from the Mapquest API and Weather API and exposes endpoints for the front-end.

--- 

### Languages, Frameworks, and Tools used
- Building: Ruby, Rails
- Testing: RSpec, Capybara, ShouldaMatchers, Webmock, VCR, Postman
- Database: PostgreSQL
- Consuming API: Faraday HTTP client library

### My Achievements
- Implemented user, session, forecast, and road_trip endpoints for a front-end service to use.
- Aggregated data from various Mapquest and Weather API endpoints to determine the weather conditions at the estimated time of arrival for a road trip's route.
- Optimized API responses to provide clear error messages and adhere to JSON API 1.0 standards.

### Project Challenges
- The biggest challenge during this project was determining how to find the weather at a given day/time for a road trip's ETA. For context, the weather API's forecasted response data comes back for a number of days, and then for each hour for every day. So it was necessary to first use the Mapquest Directions API to find the estimated driving time and then calculate what the ETA day/time would be. Once I had the proper date/time for the ETA, I had to create methods that searched through the forecasted weather data to find the proper date, and then the closest hour. Despite its challenges, tackling this part of the project was an exciting and enjoyable experience.

---

## Getting Started
#### API Keys
To use this application, you will need API keys for MapQuest and Weather APIs. You can obtain these keys by following the respective documentation for each service:
- MapQuest's Directions and Geocoding APIs: [MapQuest API Documentation](https://developer.mapquest.com/documentation/)
- Weather forecasting API: [Weather API Documentation](https://www.weatherapi.com/docs)

#### Setup a Copy of the Repository
To set up and run this application, follow these steps:
1. Clone the repository: `git clone git@github.com:westonio/sweat-or-sweater.git`
2. Navigate to the project directory: `cd sweat-or-sweater`
3. Install dependencies using Bundler: `bundle install`
4. Create and migrate the database: `rails db:{create, migrate}`
5. Set up your environment variables:
  a. Delete the `config/credentials.yml ` file that currently exists
  b. Run  `EDITOR="code --wait" rails credentials:edit` to be able to add your api keys in an encrypted file
  c. Add your keys in the following format:
    ```
      mapquest:
        key: <insert key here>
      weather:
        key: <insert key here>
    ```   
6. Start the Rails server: `rails server`
7. You can now make API requests to the application based on the endpoints described below via `http://localhost:3000`


---

### API Endpoints
#### 1. Retrieve Weather for a given location (city, state format). 
- The request uses the city and state from the query parameter to send a request to MapQuest's Geocoding API to retrieve latitude and longitude.
- Forecast data is then obtained from the Weather API using the obtained latitude and longitude.
- This endpoint send a response with the current weather, next 5 days forecast, and the hourly weather for the current day.
> Request Example: `GET 'http://localhost:3000/api/v0/forecast?location=Denver,CO'`
  ```
Response Example:
  {
    "data": {
      "id": null,
      "type": "forecast",
      "attributes": {
        "current_weather": {
          "last_updated": "2023-04-07 16:30",
          "temperature": 55.0,
          "feels_like": 53.5,
          "humidity": 70,
          "uvi": 3.8,
          "visibility": 10.0,
          "condition": "Partly Cloudy",
          "icon": "partly-cloudy.png"
        },
        "daily_weather": [
          {
            "date": "2023-04-07",
            "sunrise": "07:13 AM",
            "sunset": "08:07 PM",
            "max_temp": 60.0,
            "min_temp": 48.0,
            "condition": "Partly Cloudy",
            "icon": "partly-cloudy.png"
          },
          // ...
        ],
        "hourly_weather": [
          {
            "time": "14:00",
            "temperature": 54.5,
            "conditions": "Partly Cloudy",
            "icon": "partly-cloudy.png"
          },
          // ...
        ]
      }
    }
  }
  ```
2. User Registration
- Registration requires sending a JSON payload in the request body.
- Successful registration creates a user and generates a unique API key.
- Unsuccessful registration returns an appropriate 400-level status code and provides details on the failure (e.g., password mismatch, email already taken).
> Request Example: `POST 'http://localhost:3000/api/v0/users'`
```
request body example:
{
  "email": "user-email@example.com",
  "password": "user-password",
  "password_confirmation": "user-password"
}


response example:
{
  "data": {
    "type": "users",
    "id": "1",
    "attributes": {
      "email": "user-email@example.com",
      "api_key": "user-unique-api-key"
    }
  }
}

```

3. User Login
- Login requires sending a JSON payload in the request body.
- Successful login returns the user's API key.
- Unsuccessful login returns an appropriate 400-level status code with a description of the failure (invalid credentials).
> Request Example: `POST 'http://localhost:3000/api/v0/users'`
```
request body example:
{
  "email": "user-email@example.com",
  "password": "user-password"
}


response example:
{
  "data": {
    "type": "users",
    "id": "1",
    "attributes": {
      "email": "user-email@example.com",
      "api_key": "user-unique-api-key"
    }
  }
}
```

3. Road Trip Planning
- Planning a road trip requires sending a JSON payload in the request body with the origin location, destination location, and the API key.
- A successful response provides road trip details, including travel time and weather at the destination upon arrival.
- If no API key is given or an incorrect key is provided, a 401 (Unauthorized) is returned.
- If invalid locations are used (locations that cannot be driven to), the response returns "Impossible" for the trip time.
  
> Request Example: `POST 'http://localhost:3000/api/v0/road_trip'`
```
request body example:
{
  "origin": "Cincinnati, OH",
  "destination": "Chicago, IL",
  "api_key": "user-unique-api-key"
}


example response:
{
  "data": {
    "id": "null",
    "type": "road_trip",
    "attributes": {
      "start_city": "Cincinnati, OH",
      "end_city": "Chicago, IL",
      "travel_time": "4 hours, 30 minutes",
      "weather_at_eta": {
        "datetime": "2023-04-07 23:00",
        "temperature": 44.2,
        "condition": "Cloudy with a chance of meatballs"
      }
    }
  }
}
```
