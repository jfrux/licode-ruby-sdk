require "httparty"
require "licode/exceptions"
require "active_support/inflector"
require 'base64'
require "openssl"
module Licode
  # @private For internal use by the SDK.
  class Client
    include HTTParty

    open_timeout 2

    def initialize(service_id,service_key,service_url)
      self.class.base_uri service_url
      self.class.headers({
        "User-Agent" => "licode-ruby-sdk/#{VERSION}",
        "Content-Type" => "application/json"
      })
      @service_id = service_id
      @service_key = service_key
      @service_url = service_url
    end

    def get_rooms ()
      response = self.class.get('/rooms', {
        :headers => {
          "Authorization" => mauth_header
        }
      })

      case response.code
      when 200
        response
      when 403
        raise LicodeAuthenticationError, "Authentication failed while retrieving rooms. Service: #{@service_id}"
      else
        raise LicodeArchiveError, "The rooms could not be retrieved."
      end
    rescue StandardError => e
      raise LicodeError, "Failed to connect to Licode. Response code: #{e.message}"
    end

    def create_room (name, options={})
      response = self.class.post("/rooms", :body => {:name => name, :options => options}.to_json, :headers => {
        "Authorization" => mauth_header
      })
      case response.code
      when (200..300)
        response
      when 403
        raise LicodeAuthenticationError, "Authentication failed while creating a room. Service: #{@service_id}"
      else
        raise LicodeError, "Failed to create room. Response code: #{response}"
      end
    rescue StandardError => e
      raise LicodeError, "Failed to connect to Licode. Response code: #{e.message}"
    end

    def get_room (room)
      response = self.class.get('/rooms/' + room, {
        :headers => {
          "Authorization" => mauth_header
        }
      })
    rescue StandardError => e
      raise LicodeError, "Failed to connect to Licode. Response code: #{e.message}"
    end

    def delete_room (room)
      response = self.class.delete('/rooms/' + room, {
        :headers => {
          "Authorization" => mauth_header
        }
      })
    rescue StandardError => e
      raise LicodeError, "Failed to connect to Licode. Response code: #{e.message}"
    end

    def create_token(room, username, role)
      response = self.class.post('/rooms/' + room + '/tokens', {
        :headers => { "Authorization" => mauth_header(:username => username.to_s, :role => role) }
      })
      response
    rescue StandardError => e
      raise LicodeError, "Failed to connect to Licode. Response code: #{e.message}"
    end

    def create_service (name, key)
      response = self.class.post('/services/',
        :body => {'name' => name, 'key' => key},
        :headers => {
          "Authorization" => mauth_header
      })
    rescue StandardError => e
      raise LicodeError, "Failed to connect to Licode. Response code: #{e.message}"
    end

    def get_services ()
      response = self.class.get('/services/',
      :headers => {
        "Authorization" => mauth_header,
        "Content-Type" => "application/json"
      })
    rescue StandardError => e
      raise LicodeError, "Failed to connect to Licode. Response code: #{e.message}"
    end

    def get_service (service)
      response = self.class.get('/services/' + service,
      :headers => {
        "Authorization" => mauth_header,
        "Content-Type" => "application/json",
        "Content-Type" => "application/json"
      })
    rescue StandardError => e
      raise LicodeError, "Failed to connect to Licode. Response code: #{e.message}"
    end

    def delete_service (service)
      response = self.class.delete('/services/' + service,
      :headers => {
        "Authorization" => mauth_header,
        "Content-Type" => "application/json"
      })
    rescue StandardError => e
      raise LicodeError, "Failed to connect to Licode. Response code: #{e.message}"
    end

    def get_room_users (room)
      response = self.class.get('/rooms/' + room + '/users/',
      :headers => {
        "Authorization" => mauth_header,
        "Content-Type" => "application/json"
      })
    rescue StandardError => e
      raise LicodeError, "Failed to connect to Licode. Response code: #{e.message}"
    end

    private
    def mauth_header(opts = {})
      header = "MAuth realm=#{@service_url},mauth_signature_method=HMAC_SHA1"
      timestamp = (Time.now.to_f * 1000).to_i
      cnounce = rand(99999)

      toSign = timestamp.to_s + "," + cnounce.to_s

      if opts[:username] && !opts[:username].empty? && opts[:role] && !opts[:role].empty?
        header += ',mauth_username='
        header +=  opts[:username]
        header += ',mauth_role='
        header +=  opts[:role]

        toSign += ',' + opts[:username] + ',' + opts[:role]
      end

      signed = calculateSignature(toSign, @service_key)

      header += ',mauth_serviceid='
      header +=  @service_id
      header += ',mauth_cnonce='
      header += cnounce.to_s
      header += ',mauth_timestamp='
      header +=  timestamp.to_s
      header += ',mauth_signature='
      header +=  signed

      header
    end

    private
    def calculateSignature (toSign, key)
      digest = OpenSSL::Digest.new('sha1')
      hex = OpenSSL::HMAC.hexdigest(digest,key,toSign)
      signed   = Base64.encode64("#{hex}")
      return signed
    end
  end
end
