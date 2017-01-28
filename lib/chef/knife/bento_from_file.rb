class Chef
  class Knife
    class BentoFromFile < Chef::Knife
      include BentoBase

      banner 'knife bento from file PATH FILE'

      def verify_args!
        if name_args.size == 2
          unless valid_path?(name_args[0])
            show_usage
            exit 1
          end
          unless valid_file?(name_args[1])
            puts "parameter '#{name_args[1]}' is not a valid file"
            exit 1
          end
        else
          show_usage
          exit 1
        end
      end

      def run
        verify_args!
        ask_unseal_vault
        vault_auth!
        edit_secret_item_from_file(name_args[0], name_args[1])
      end
    end
  end
end
