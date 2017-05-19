module Warhol
  module Support
    module Inflector
      def demodulize(str)
        str.split('::').last
      end

      def underscore(str)
        tokens = str.split('::')

        tokens.map! do |token|
          token.split('')
               .slice_when { |p, n| p =~ /[[:lower:]]/ && n =~ /[[:upper:]]/ }
               .to_a
               .inject('') { |m, a| next a.join if m.empty?; "#{m}_#{a.join}" }
               .downcase
        end

        tokens.join('/')
      end
    end
  end
end