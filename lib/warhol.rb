# frozen_string_literal: true

require 'cancancan'
require 'warhol/version'

module Warhol
  autoload :Ability, 'warhol/ability'
  autoload :Config,  'warhol/config'
  autoload :Router,  'warhol/router'
  autoload :Support, 'warhol/support'

  Object.const_set(:Ability, Warhol::Router)
end
