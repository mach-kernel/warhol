# frozen_string_literal: true

module Warhol
  class Router
    include ::CanCan::Ability
    include Warhol::Support::Inflector

    attr_reader :user

    def initialize(user)
      return if user.nil?
      @user = user
      apply_permissions
    end

    def roles_to_apply
      if !Warhol::Config.instance.role_proc.nil?
        Warhol::Config.instance.role_proc.call(user)
      else
        user.send(Warhol::Config.instance.role_accessor)
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
            user, 
            &Warhol::Config.instance.ability_classes[k].permissions
          )
        end
    end
  end
end
