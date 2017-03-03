class Chef
  class Knife
    class BentoShow < Chef::Knife
      include BentoBase

      banner 'knife bento show PATH [ITEM]'

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
        vault_config!
        ask_unseal_vault
        vault_auth!
        print_secret(name_args[0]) if name_args.size == 1
        print_secret_item(name_args[0], name_args[1]) if name_args.size == 2
      end
    end
  end
end
