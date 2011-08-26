require 'google_oauth/hash_response'
require 'google_oauth/array_response'
require 'google_oauth/contacts'
require 'google_oauth/calendar'
require 'google_oauth/prediction'

module GoogleOAuth
  class Client
    
    def initialize(options = {})
      @application_id = options[:client_id]
      @application_secret = options[:client_secret]
      @callback = options[:redirect]
      @token = options[:token]
    end
  
    def authorize_url(options = {})
      options[:scope] ||= 'https://www.google.com/m8/feeds/'
      consumer.auth_code.authorize_url(
        :redirect_uri => options[:callback] || @callback,
        :scope => options[:scope]
      )
    end
    
    def authorize(options = {})
      @access_token ||= consumer.auth_code.get_token(
        options[:code],
        :redirect_uri => options[:callback] || @callback
      )
      @token = @access_token.token
      @access_token
    end
    

      def consumer
        @consumer ||= OAuth2::Client.new(
          @application_id,
          @application_secret,
          { 
            :site => "https://accounts.google.com",
            :authorize_url => '/o/oauth2/auth',
            :token_url => '/o/oauth2/token'          }
        )
      end

      def access_token
        OAuth2::AccessToken.new(consumer, @token)
      end
      
      def _get_jsonc(url, params={})
        params.merge! 'alt' => 'jsonc'
        res = _get(url, params)
        GoogleOAuth::HashResponse.new(JSON.parse(res)) rescue res
      end
      
      def _get_json(url, params={})
        params.merge! 'alt' => 'json'
        res = _get(url, params)
        JSON.parse(res) rescue res
      end
      
      def _get(url, params={})
        access_token.get(url, params)
      end

      def _post_json(url, params={})
        params.merge! headers: {'Content-Type' => 'application/json'}
        res = _post(url, params)
        GoogleOAuth::HashResponse.new(JSON.parse(res)) rescue res
      end

      def _post(url, params={})
        access_token.post(url, params)
      end

      def _delete(url)
        oauth_response = access_token.delete(url)
        JSON.parse(oauth_response) rescue oauth_response
      end
  end
end
   
