require 'httparty'
require 'json'
require './lib/roadmap.rb'

  class Kele
    include HTTParty
    include Roadmap
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

    def get_messages(page=nil)

      address_mentor = 'https://www.bloc.io/api/v1/message_threads'
      response = self.class.get(address_mentor, values: {"page" => page}, headers: { "authorization" => @auth })
      @message_parse = JSON.parse(response.body)
    end


    def create_message(sender, recipient_id, token, subject, message)
     response = self.class.post("https://www.bloc.io/api/v1/messages", values: {sender: sender, recipient_id: recipient_id, token: token, subject: subject, "stripped-text" => message}, headers: {"authorization" => @auth})
     case response.code
       when 200
         puts "Great job, It is up and running!"
       when 404
         puts "Sorry! Try again."
       when 500...600
         puts "ERROR #{response.code}"
     end
    end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment, enroll_idß)
    response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions",
          headers: { "authorization" => @auth },
          body: {
            "assignment_branch" => assignment_branch,
            "assignment_commit_link" => assignment_commit_link,
            "checkpoint_id" => checkpoint_id,
            "comment" => comment,
            "enrollment_id" => enroll_id
          })
        @checkpoint = JSON.parse(response.body)
  end

  def update_submission(id, assign_branch, assign_commit_link, check_id, assign_comment, enroll_id)
    response = self.class.put("https://www.bloc.io/api/v1/checkpoint_submissions/#{id}",
      headers: { "authorization" => @auth },
      body: {
        "assignment_branch" => assign_branch,
        "assignment_commit_link" => assign_commit_link,
        "checkpoint_id" => check_id,
        "comment" => assign_comment,
        "enrollment_id" => enroll_id
      })
    @update_check = JSON.parse(response.body)
  end

end
