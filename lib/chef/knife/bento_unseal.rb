class Chef
  class Knife
    class BentoUnseal < Chef::Knife
      include BentoBase

      banner 'knife bento unseal'

      def run
        vault_config!
        unseal_vault!
      end
    end
  end
end
