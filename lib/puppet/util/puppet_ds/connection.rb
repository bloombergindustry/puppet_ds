require 'puppet'
require 'faraday'
require 'json'
require 'openssl'

# Util Module
module Puppet::Util::PuppetDs
  # Helper class
  class Connection
    attr_accessor :context
    attr_reader :url

    def initialize(context, opts = {})
      @url = opts[:url] || "https://#{Puppet.settings[:certname]}:4433"

      ssl_options = Puppet::Util::PuppetDs::Connection.puppet_certs
      ssl_options[:verify] = true

      @connection = Faraday.new(url: @url, ssl: ssl_options, headers: { 'Content-Type' => 'application/json' })
      @context    = context

      context.debug("Created connection to #{@url}")
    end

    def config
      path = '/rbac-api/v2/ldap'
      context.debug("Executing GET #{path} to #{@connection.url_prefix}")
      result = @connection.get(path)

      return JSON.parse(result.body) if result.success?

      raise StandardError, format_error(result)
    end

    def create=(conf)
      path = '/rbac-api/v1/command/ldap/create'
      context.debug("Executing POST #{path} to #{@connection.url_prefix}")
      result = @connection.post(path, conf.to_json)

      return true if result.success?

      raise StandardError, format_error(result)
    end

    def update=(conf)
      path = '/rbac-api/v1/command/ldap/update'
      context.debug("Executing POST #{path} to #{@connection.url_prefix}")
      result = @connection.post(path, conf.to_json)

      return true if result.success?

      raise StandardError, format_error(result)
    end

    def validate(conf)
      path = '/rbac-api/v1/command/ldap/test'
      context.debug("Executing POST #{path} to #{@connection.url_prefix}")
      result = @connection.post(path, conf.to_json)

      return true if result.success?

      raise StandardError, format_error(result)
    end

    def self.puppet_certs
      {
        ca_file:     Puppet.settings[:cacert],
        client_cert: OpenSSL::X509::Certificate.new(File.read(Puppet.settings[:hostcert])),
        client_key:  OpenSSL::PKey.read(File.read(Puppet.settings[:hostprivkey])),
      }
    end

    private

    def format_error(result)
      "Error. HTTP: #{result.status}, BODY: #{result.body}"
    end
  end
end
