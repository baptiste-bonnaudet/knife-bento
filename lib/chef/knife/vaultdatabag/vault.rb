require 'vault'

class Chef
  class Knife
    module VaultdatabagBase
      def secret_data(secret)
        Vault.with_retries(Vault::HTTPConnectionError, attempts: 5) do
          secret_data = Vault.logical.read("secret/#{secret}").data
        end
        unless secret_data.nil? return secret_data

        error_and_exit "could not retreive secret, verify name or connection"
      end

      def print_secret(secret)
        secret_data(secret).keys.each do |key|
          puts key
        end
      end

      def print_secret_item(secret, item)
        puts secret_data(secret)[item.to_sym]
      end

      def edit_vault_item(secret, item)
        File.new "/tmp/vaultdatabag.tmp"
        system( "#{ENV[EDITOR] /tmp/vaultdatabag.tmp}")
      end
    end
  end
end
