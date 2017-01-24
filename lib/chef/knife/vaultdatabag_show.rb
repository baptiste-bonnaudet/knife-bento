class Chef
  class Knife
    class VaultdatabagShow < Chef::Knife
      include VaultdatabagBase

      banner "knife vault edit PATH ITEM"

      def verify_args!
        if name_args.size == 1
          unless valid_path?(name_args[0])
            show_usage
            exit 1
          end
        elsif name_args.size == 2
          unless valid_path?(name_args[0]) && valid_item?(name_args[1])
            show_usage
            exit 1
          end
        else
          show_usage
          exit 1
        end
      end

      def run
        verify_args!
        print_secret(name_args[0]) if name_args.size == 1
        print_secret_item(name_args[0], name_args[1]) if name_args.size == 2
      end
    end
  end
end
