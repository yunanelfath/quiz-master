class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  helper_method :hash_for
  helper_method :json_for

  protected
    def json_for(target, serializer = nil, options = {})
      return nil unless target
      serializer ||= target.active_model_serializer
      options[:scope] ||= current_user
      options[:url_options] ||= url_options
      serializer.new(target, options).to_json
    end

    def hash_for(target, serializer = nil, options = {})
      return nil unless target
      serializer ||= target.active_model_serializer
      options[:scope] ||= current_user
      options[:url_options] ||= url_options
      serializer.new(target, options).as_json
    end
end
