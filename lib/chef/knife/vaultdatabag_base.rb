require 'chef/knife'
require 'chef/knife/vaultdatabag/vault'
class Chef
  class Knife
    module VaultdatabagBase # rubocop:disable Metrics/ModuleLength

    def valid_path?(path)
      return true if path[/[a-zA-Z]+/] == path
      return false
    end

    def valid_item?(item)
      return true if item[/[a-zA-Z]+/] == item
      return false
    end

      def error_and_exit(*messages)
        messages.each { |m| ui.error m }
        exit 1
      end
    end
  end
end
