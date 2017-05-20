# frozen_string_literal: true

module Warhol
  class Ability
    class << self
      include Warhol::Support::Inflector

      attr_reader :permissions

      def define_permissions(&block)
        @permissions ||= block
        register
        nil
      end

      private

      def register
        raise(
          'Ability classes should implement .name if they are anonymous!'
        ) if name.nil?

        Warhol::Config.instance
                      .ability_classes[demodulize(name).downcase] = self
      end
    end
  end
end
