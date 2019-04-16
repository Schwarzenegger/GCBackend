module SpecHelpers
  module ApiHeader
    def mount_header(token, v = 1)
      {
        'Authorization' => "Token token=#{token}",
        'Accept' => "application/vnd.gc_backend-v#{v}",
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Cache-Control' => 'no-cache'
      }
    end
  end
end
