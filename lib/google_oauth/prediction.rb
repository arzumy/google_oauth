module GoogleOAuth
  class Client
    def prediction_train!(id)
      _post_json 'https://www.googleapis.com/prediction/v1.3/training', {body: {id: id}.to_json}
    end
  end
end