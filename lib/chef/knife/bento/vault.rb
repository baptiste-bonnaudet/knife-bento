require 'vault'

class Chef
  class Knife
    module BentoBase

      def copy_frozen_hash(secret)
        return secret.inject({}) do |new, (name, value)|
            new[name] = value;
            new
        end
      end

      def secret_data(secret)
        secret_data = {}
        Vault.with_retries(Vault::HTTPConnectionError, attempts: 5) do
          return secret_data if
            secret_data = Vault.logical.read("secret/#{secret}").data # rubocop:disable Lint/AssignmentInCondition
        end
      rescue
        log_error_and_exit 'could not retreive secret, verify name or connection'
      end

      def list_secrets!
        puts Vault.logical.list("secret")
      end

      def secret_exists?(secret)
        Vault.logical.list("secret").include?(secret)
      end

      def secret_item_exists?(secret,item)
        secret_data(secret)[item.to_sym].nil?
      end

      def vault_sealed?
        Vault.sys.seal_status.sealed?
      end

      def unseal_vault!
        return unless vault_sealed?
        loop do
          shard = ask "#{Vault.sys.seal_status.t -
                         Vault.sys.seal_status.progress} " \
                         'keys left to unseal, enter next key:'
          Vault.sys.unseal(shard.strip)
          break unless vault_sealed?
        end
      end

      def ask_unseal_vault
        return unless vault_sealed?
        confirm = ask(
          'Vault is sealed do you want to unseal it? [Y/N] '
        ) { |yn| yn.limit = 1, yn.validate = /[yn]/i }

        exit unless confirm.casecmp('y').zero?
        unseal_vault!
      end

      def seal_vault!
        return if vault_sealed?
        puts '[WARNING] This action will seal the vault and will affect service!'
        confirm = ask(
          'Do you have great sureness? [Y/N] '
        ) { |yn| yn.limit = 1, yn.validate = /[yn]/i }
        Vault.sys.seal if confirm
      end

      def print_secret(secret)
        secret_data(secret).keys.each do |key|
          puts key
        end
      end

      def print_secret_item(secret, item)
        i = secret_data(secret)[item.to_sym]
        unless i.to_s.strip.empty?
          puts i
          return
        end
        log_error_and_exit 'item does not exist'
      end

      def valid_json?(json)
        JSON.parse(json)
        return true
      rescue JSON::ParserError
        return false
      end

      def valid_databag_item?(item_content)
        return true if JSON.parse(item_content)['id']
        false
      end

      def create_secret_item(secret, item)
        # get existing secret content
        secret_hash = copy_frozen_hash(secret_data(secret))

        if secret_item_exists?(secret,item)
          log_error_and_exit "#{secret}/#{item} already exist"
        end

        secret_hash[item.to_sym] = "{}"

        # write content to vault
        Vault.logical.write("secret/#{secret}", secret_hash)
      end

      def edit_secret_item(secret, item)
        if secret_item_exists?(secret,item)
          log_error_and_exit("Cannot load secret item #{secret}/#{item}")
        end

        # read item
        item_content = secret_data(secret)[item.to_sym]
        item_content = '' if item_content.to_s.strip.empty?

        # write it to tmp file
        tmp_file = '/tmp/bento.tmp'
        File.open(tmp_file, 'w') { |file| file.write(item_content) }

        # open editor to change file
        system("#{ENV['EDITOR']} #{tmp_file}")

        # read file
        item_content = File.open(tmp_file, 'rb', &:read)

        # delete file
        File.delete(tmp_file)

        # validate json and id field
        unless valid_databag_item?(item_content)
          log_error_and_exit "invalid databag item, 'id' field must exist"
        end
        unless valid_json?(item_content)
          log_error_and_exit "Invalid json syntax for #{secret}/#{item}"
        end
        unless secret_item_exists?(secret,item)
            log_error_and_exit "Name mismatch, create item first"
        end

        # get existing secret content
        secret_hash = copy_frozen_hash(secret_data(secret))
        secret_hash[JSON.parse(item_content)['id'].to_sym] = item_content

        # write content to vault
        Vault.logical.write("secret/#{secret}", secret_hash)
      end

      def edit_secret_item_from_file(secret, file)

        # read file
        item_content = File.open(file, 'rb', &:read)

        # validate json and id field
        unless valid_databag_item?(item_content)
          log_error_and_exit "invalid databag item, 'id' field must exist"
          File.delete(tmp_file)
        end
        unless valid_json?(item_content)
          log_error_and_exit "Invalid json syntax for #{secret}/#{item}"
          File.delete(tmp_file)
        end

        # get existing secret content
        secret_hash = copy_frozen_hash(secret_data(secret))
        secret_hash[JSON.parse(item_content)['id'].to_sym] = item_content

        # write content to vault
        Vault.logical.write(
          "secret/#{secret}",
          secret_hash
        )
      end
    end
  end
end
