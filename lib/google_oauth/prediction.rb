module GoogleOAuth
  class Client
    def prediction_train!(model)
      _post_json 'https://www.googleapis.com/prediction/v1.3/training', {body: {id: model}.to_json}
    end

    def prediction_check(model)
      _get_json "https://www.googleapis.com/prediction/v1.3/training/#{URI.escape(model, '/.')}"
    end
  end
end