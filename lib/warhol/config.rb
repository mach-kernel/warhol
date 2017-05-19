# frozen_string_literal: true

module Warhol
  class Config
    class << self
      attr_reader :instance

      def new(&block)
        @instance = super(&block)
      end
    end

    def initialize
      yield(self)
    end

    # Allow to receive field= too
    def respond_to_missing?(method_name, *args)
      store.keys.any? { |k| method_name.to_s.include?(k.to_s) } || super
    end

    def method_missing(sym, *args, &_block)
      return super unless respond_to_missing?(sym)

      method_str = sym.to_s
      return store[method_str.to_sym] unless method_str.include?('=')
      store[method_str.delete('=').to_sym] = args.first
    end

    private

    def store
      @store ||= {
        ability_classes: {},
        ability_parent: Object,
        role_accessor: :roles,
        role_proc: nil
      }
    end
  end
end
