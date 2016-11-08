require 'uri'
require 'net/http'
require 'cgi'
require 'json'
require 'puppet_x/util/digest_auth'
require 'puppet_x/wildfly/cli_command'

module PuppetX
  module Wildfly
    class APIClient
      def initialize(address, port, user, password, timeout = 60)
        @username = user
        @password = password

        @uri = URI.parse "http://#{address}:#{port}/management"
        @uri.user = CGI.escape(user)
        @uri.password = CGI.escape(password)

        @http_client = Net::HTTP.new @uri.host, @uri.port, nil
        @http_client.read_timeout = timeout
      end

      def authz_header
        digest_auth = Net::HTTP::DigestAuth.new
        authz_request = Net::HTTP::Get.new @uri.request_uri
        response = @http_client.request authz_request

        # work-around for intermittent auth error
        sleep 0.1

        if response['www-authenticate'] =~ /digest/i
          digest_auth.auth_header @uri, response['www-authenticate'], 'POST'
        else
          response['www-authenticate']
        end
      end

      def send(body, ignore_outcome = false, detyped = false)
        http_request = Net::HTTP::Post.new @uri.request_uri
        http_request.add_field 'Content-type', 'application/json'
        authz = authz_header
        if authz =~ /digest/i
          http_request.add_field 'Authorization', authz
        else
          http_request.basic_auth @username, @password
        end

        if detyped
          http_request.body = body.to_json
        else
          detyped_request = CLICommand.new(body).to_detyped_request
          http_request.body = detyped_request.to_json
        end

        http_response = @http_client.request http_request

        response = JSON.parse(http_response.body)

        unless response['outcome'] == 'success' || ignore_outcome
          raise "Failed with: #{response['failure-description']} for #{body.to_json}"
        end

        response
      end
    end
  end
end
