require "licode/room"
require "licode/client"

module Licode
  class Nuve
    attr_reader :service_id, :service_key, :service_url
    ##
    # Create a new Nuve object.
    #
    # @param [String] service_id Your ServiceId. See the Nuve Mongo DB.
    # @param [String] service_key Your ServiceKey.
    # @param [String] service_url base URL to your licode instance.

    def initialize (service_id, service_key, service_url)
      @service_id = service_id
      @service_key = service_key
      @service_url = service_url
    end

    # def create_service(name, key)
    # 	response = client.create_service(name,key});
    #   Service.new name,key
    # end

    def create_room(name,opts={})
      response = client.create_room(name,opts)
      Room.new response['_id'], opts
    end

    def create_token(room, username, role)
      client.create_token(room, username, role)
    end

    protected

    def client
      @client ||= Client.new service_id, service_key, service_url
    end
  end
end
