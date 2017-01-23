class Chef
  class Knife
    class VaultdatabagDebug < Chef::Knife
      include VaultdatabagBase

      deps do
        require 'pry'
      end

      # this is just here for easily accessing the knife commands from pry
      def run
        binding.pry # rubocop:disable Lint/Debugger

        puts 'complete'
      end
    end
  end
end
