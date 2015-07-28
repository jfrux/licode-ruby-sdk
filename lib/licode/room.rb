require "licode/client"
module Licode
  # Represents an Licode room.
  #
  # Use the Nuve.create_room() method to create an Licode room. Use the
  # room_id property of the Room object to get the room room_id.
  class Room
    attr_reader :room_id, :users, :opts

    # @private
    def initialize(room_id, opts={})
      @room_id = room_id
      @opts = opts
    end

    def create_token(username, role)
      client.create_token(room_id, username, role)
    end

    def users
      client.get_room_users(room_id);
    end

    # @private
    def to_s
      @room_id
    end
  end
end
