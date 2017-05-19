# frozen_string_literal: true

module Warhol
  class Router
    include CanCan::Ability
    include Warhol::Support::Inflector

    def initialize(user)
      return if user.nil?
      @user = user
      apply_permissions
    end

    private

    attr_reader :user

    def apply_permissions
      (Warhol::Config.ability_classes & roles_to_apply).each do |k|
        instance_exec(user, &Warhol::Config.ability_classes[k].permissions)
      end
    end

    def roles_to_apply
      if Warhol::Config.role_proc
        Warhol::Config.role_proc.call(user)
      else
        user.send(Warhol::Config.role_accessor)
      end
    end
  end
end
