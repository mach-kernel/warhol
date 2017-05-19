module Warhol
  class Router
    include CanCan::Ability
    include Warhol::Support::Inflector

    def initialize(user)
      return unless !!user
      @user = user
      apply_permissions
    end

    private

    attr_reader :user

    def apply_permissions


      Warhol::Config.ability_classes.each do |klass|
        role_name = klass.name.split('::').last.
        next unless 
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