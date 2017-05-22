# frozen_string_literal: true

module Warhol
  class Router
    include ::CanCan::Ability
    include Warhol::Support::Inflector

    attr_reader :object

    def initialize(object)
      return if object.nil?
      @object = object

      decorate_accessors
      apply_permissions
    end

    def roles_to_apply
      if !Warhol::Config.instance.role_proc.nil?
        Warhol::Config.instance.role_proc.call(object)
      else
        object.send(Warhol::Config.instance.role_accessor)
      end
    end

    private

    def apply_permissions
      Warhol::Config
        .instance
        .ability_classes
        .keys
        .map(&:downcase) & roles_to_apply.map(&:downcase).each do |k|
          instance_exec(
            object,
            &Warhol::Config.instance.ability_classes[k].permissions
          )
        end
    end

    def decorate_accessors
      self.class.instance_exec(
        Warhol::Config.instance.additional_accessors
      ) { |a| a.each { |m| alias_method m.to_sym, :object } } 
    end
  end
end
