module Licode

  # Defines errors raised by methods of the Licode Ruby SDK.
  class LicodeError < StandardError; end
  # Defines errors raised when authentication fails
  class LicodeAuthenticationError < LicodeError; end

end
