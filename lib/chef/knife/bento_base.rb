require 'chef/knife'
require 'chef/knife/bento/vault'

require 'highline/import'

class Chef
  class Knife
    module BentoBase
      def log_error_and_exit(*messages)
        messages.each { |m| ui.error m }
        exit 1
      end

      def log_debug(*messages)
        messages.each { |m| Chef::Log.debug(m) }
      end

      # checks
      def valid_path?(path)
        path[/[a-zA-Z.-_]+/] == path || false
      end

      def valid_item?(item)
        item[/[a-zA-Z.-_]+/] == item || false
      end

      def valid_file?(path)
        File.file?(path)
      end

      # elements
      def vault_address
        Chef::Config[:knife][:vault_address] ||
          log_error_and_exit('Invalid Vault Address, check knife configuration')
      end

      def vault_token
        Chef::Config[:knife][:vault_token] ||
          log_error_and_exit('Invalid Vault Token, check knife configuration')
      end

      def vault_ssl_pem_file
        path = Chef::Config[:knife][:vault_ssl_pem_file]

        if path.nil?
          log_error_and_exit(
            'Empty path for vault_ssl_pem_file'
          )
        end

        unless File.file?(path)
          log_error_and_exit(
            "Path for vault_ssl_pem_file '#{path}' is not a valid file"
          )
        end

        path
      end

      def vault_ssl_verify
        ssl = Chef::Config[:knife][:vault_ssl_verify]
        return true if ssl.casecmp('true').zero?
        return false if ssl.casecmp('false').zero?

        log_error_and_exit "#{ssl} not in true/false value"
      end

      def vault_timeout
        timeout = Chef::Config[:knife][:vault_timeout]
        return timeout if timeout.to_i > 0
        log_error_and_exit "vault_timeout must be positive (#{timeout})"
      end

      def vault_ssl_timeout
        timeout = Chef::Config[:knife][:vault_ssl_timeout]
        return timeout if timeout.to_i > 0
        log_error_and_exit "vault_ssl_timeout must be positive (#{timeout})"
      end

      def vault_open_timeout
        timeout = Chef::Config[:knife][:vault_open_timeout]
        return timeout if timeout.to_i > 0
        log_error_and_exit "vault_open_timeout must be positive (#{timeout})"
      end

      def vault_read_timeout
        timeout = Chef::Config[:knife][:vault_read_timeout]
        return timeout if timeout.to_i > 0
        log_error_and_exit "vault_read_timeout must be positive (#{timeout})"
      end

      def vault_config
        Vault.configure do |config| # rubocop:disable Metrics/BlockLength
          log_debug "vault_address: #{Chef::Config[:knife][:vault_address]}"
          log_debug "vault_token: #{Chef::Config[:knife][:vault_token]}"
          log_debug "vault_ssl_pem_file: #{Chef::Config[:knife][:vault_ssl_pem_file]}"
          log_debug "vault_ssl_verify: #{Chef::Config[:knife][:vault_ssl_verify]}"
          log_debug "vault_timeout: #{Chef::Config[:knife][:vault_timeout]}"
          log_debug "vault_ssl_timeout: #{Chef::Config[:knife][:vault_ssl_timeout]}"
          log_debug "vault_open_timeout: #{Chef::Config[:knife][:vault_open_timeout]}"
          log_debug "vault_read_timeout: #{Chef::Config[:knife][:vault_read_timeout]}"

          # The address of the Vault server, also read as ENV["VAULT_ADDR"]
          config.address = vault_address

          # The token to authenticate with Vault, also read as ENV["VAULT_TOKEN"]
          config.token = vault_token

          # Custom SSL PEM, also read as ENV["VAULT_SSL_CERT"]
          unless Chef::Config[:knife][:vault_ssl_pem_file].nil?
            config.ssl_pem_file = vault_ssl_pem_file
          end

          # Use SSL verification, also read as ENV["VAULT_SSL_VERIFY"]
          unless Chef::Config[:knife][:vault_ssl_verify].nil?
            config.ssl_verify = vault_ssl_verify
          end

          # Timeout the connection after a certain amount of time (seconds),
          # also read as ENV["VAULT_TIMEOUT"]
          unless Chef::Config[:knife][:vault_timeout].nil?
            config.timeout = vault_timeout
          end

          # It is also possible to have finer-grained controls over the timeouts,
          # these may also be read as environment variables
          unless Chef::Config[:knife][:vault_ssl_timeout].nil?
            config.ssl_timeout = vault_ssl_timeout
          end

          unless Chef::Config[:knife][:vault_open_timeout].nil?
            config.open_timeout = vault_open_timeout
          end

          unless Chef::Config[:knife][:vault_read_timeout].nil?
            config.read_timeout = vault_read_timeout
          end
        end
      end

      def vault_auth!
        vault_config
      end
    end
  end
end
