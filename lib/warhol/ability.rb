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
        Warhol::Config.ability_classes[demodulize(self.name)] = self
      end
    end
  end
end
