class Chef
  class Knife
    class BentoList < Chef::Knife
      include BentoBase

      banner 'knife bento list'

      def run
        list_secrets!
      end
    end
  end
end
