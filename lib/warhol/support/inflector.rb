module Warhol
  module Support
    module Inflector
      def demodulize(str)
        str.split('::').last
      end

      def underscore(str)
        str = demodulize(str) if str.include?('::')
        
      end
    end
  end
end