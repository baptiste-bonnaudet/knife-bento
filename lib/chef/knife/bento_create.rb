class Chef
  class Knife
    class BentoCreate < Chef::Knife
      include BentoBase

      banner 'knife bento create BAG [ITEM]'

      def verify_args!
        if name_args.size == 2
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
        create_secret_item(name_args[0], name_args[1])
      end
    end
  end
end
