require 'vault'

class Chef
  class Knife
    module VaultdatabagBase

      def secret_data(secret)
        begin
          secret_data = {}
          Vault.with_retries(Vault::HTTPConnectionError, attempts: 5) do
            return secret_data if secret_data = Vault.logical.read("secret/#{secret}").data
          end
        rescue
          error_and_exit "could not retreive secret, verify name or connection"
        end
      end

      def print_secret(secret)
        secret_data(secret).keys.each do |key|
          puts key
        end
      end

      def print_secret_item(secret, item)
        i = secret_data(secret)[item.to_sym]
        if i.to_s.strip.length > 0
          puts i
          return
        end
        error_and_exit "item does not exist"
      end

      def valid_json?(json)
        begin
          JSON.parse(json)
          return true
        rescue JSON::ParserError => e
          return false
        end
      end

      def valid_databag_item?(item_content)
        return true if JSON.parse(item_content)["id"]
        return false
      end

      def edit_secret_item(secret, item)
        # read item
        item_content = secret_data(secret)[item.to_sym]
        if item_content.to_s.strip.length == 0
          item_content = ''
        end

        # write it to tmp file
        tmp_file = "/tmp/vaultdatabag.tmp"
        File.open(tmp_file, 'w') { |file| file.write(item_content) }

        # open editor to change file
        system( "#{ENV['EDITOR']} #{tmp_file}")

        # read file
        item_content = File.open(tmp_file, 'rb') { |f| f.read }

        # validate json and id field
        unless valid_databag_item?(item_content)
          error_and_exit "invalid databag item, 'id' field must exist"
          File.delete(tmp_file)
        end
        unless valid_json?(item_content)
          error_and_exit "Invalid json syntax for #{secret}/#{item}"
          File.delete(tmp_file)
        end

        # write content to vault
        Vault.logical.write("secret/#{secret}", data = { item => item_content})

        # delete file
        File.delete(tmp_file)
      end

      def edit_secret_item_from_file(secret, file)
        puts "#{secret} #{file}"
        # read file
        item_content = File.open(file, 'rb') { |f| f.read }

        # validate json and id field
        unless valid_databag_item?(item_content)
          error_and_exit "invalid databag item, 'id' field must exist"
          File.delete(tmp_file)
        end
        unless valid_json?(item_content)
          error_and_exit "Invalid json syntax for #{secret}/#{item}"
          File.delete(tmp_file)
        end

        # write content to vault
        Vault.logical.write("secret/#{secret}",
          data = { JSON.parse(item_content)["id"] => item_content})


      end



    end
  end
end
