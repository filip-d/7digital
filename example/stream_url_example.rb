require '../lib/sevendigital'

sd_client = Sevendigital::Client.new("sevendigital.yml")
@trackId = 1810721
@formatId = 26

api_request = sd_client.create_api_request(:GET, "stream/catalogue", {:trackId => @trackId, :userId => "123456", :formatId => @formatId})
api_request.api_service = :media
api_request.require_signature
stream_url = sd_client.operator.get_request_uri(api_request)
puts stream_url
curl_command = "curl -o \"track-#{@trackId}.mp3\" -v \"#{stream_url}\""
puts curl_command
exec curl_command