module API
  class Base < Grape::API
    include ActionController::HttpAuthentication::Token::ControllerMethods
    default_format :json
    format :json

    mount API::V1::Base
  end
end
