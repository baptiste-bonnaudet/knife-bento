class Chef
  class Knife
    class BentoSeal < Chef::Knife
      include BentoBase

      banner 'knife bento seal'

      def run
        seal_vault!
      end
    end
  end
end
