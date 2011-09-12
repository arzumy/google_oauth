module GoogleOAuth
  class Client
    def prediction_train!(model)
      _post_json 'https://www.googleapis.com/prediction/v1.3/training', {body: {id: model}.to_json}
    end

    def prediction_update!(model, label, *signal)
      body = { classLabel: label, csvInstance: signal }
      _put_json "https://www.googleapis.com/prediction/v1.3/training/#{URI.escape(model, '/.')}", {body: body.to_json}
    end

    def prediction_check(model)
      _get_json "https://www.googleapis.com/prediction/v1.3/training/#{URI.escape(model, '/.')}"
    end

    def prediction_predict(model, *signal)
      body = { input: { csvInstance: signal }}
      _post_json "https://www.googleapis.com/prediction/v1.3/training/#{URI.escape(model, '/.')}/predict", {body: body.to_json}
    end
  end
end