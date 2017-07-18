module Roadmap

    def get_roadmap(roadmap_id)
      roadmap_url = 'https://www.bloc.io/api/v1/roadmaps/' + roadmap_id.to_s
      response = self.class.get(roadmap_url, headers: { "authorization" => @auth })
      @roadmap_parse = JSON.parse(response.body)
    end

    def get_checkpoints(checkpoint_id)
      checkpoint_url = 'https://www.bloc.io/api/v1/checkpoints/' + checkpoint_id.to_s
      response = self.class.get(checkpoint_url, headers: { "authorization" => @auth })
      @checkpoint_parse = JSON.parse(response.body)
    end


end
