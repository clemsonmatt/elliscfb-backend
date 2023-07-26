class ImportConnection < ApplicationService
  def call
    Faraday.new(url: 'https://api.collegefootballdata.com') do |builder|
      # Calls MyAuthStorage.get_auth_token on each request to get the auth token
      # and sets it in the Authorization header with Bearer scheme.
      builder.request :authorization, 'Bearer', -> { ENV['CFBD_API_KEY'] }

      # Sets the Content-Type header to application/json on each request.
      # Also, if the request body is a Hash, it will automatically be encoded as JSON.
      builder.request :json

      # Parses JSON response bodies.
      # If the response body is not valid JSON, it will raise a Faraday::ParsingError.
      builder.response :json
    end
  end
end
