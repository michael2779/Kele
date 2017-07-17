require 'httparty'
require 'json'

  class Kele
    include HTTParty
    base_uri 'https://www.bloc.io/api/v1'

    def initialize(email, password)
      response = self.class.post('/sessions', body: {"email": email, "password": password})

      case response.code
        when 200
          puts "All good!"
        when 404
          puts "Invalid credentials! Try again."
        when 500...600
          puts "ZOMG ERROR #{response.code}"
      end

      @auth = response['auth_token']
    end

    def get_me
      response = self.class.get('https://www.bloc.io/api/v1/users/me', headers: { "authorization" => @auth })
      puts response
      @parsed_data = JSON.parse(response.body)
      puts @parsed_data
    end

    def get_mentor_availability(mentor_id)

      address_mentor = 'https://www.bloc.io/api/v1/mentors/' + mentor_id.to_s + '/student_availability'
      response = self.class.get(address_mentor, headers: { "authorization" => @auth })
      @mentor_parse = JSON.parse(response.body)
    end

  end
