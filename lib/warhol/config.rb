
# frozen_string_literal: true

module Warhol
  class Config
    class << self
      def new(&block)
        return @instance unless @instance.nil?
        @instance = super(&block)
      end

      def instance
        @instance ||= new
      end
    end

    def initialize(&block)
      yield(self) unless block.nil?
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
        additional_accessors: %w[],
        role_accessor: nil,
        role_proc: nil
      }
    end
  end
end
