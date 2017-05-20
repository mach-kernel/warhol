# warhol

A better way to do [CanCanCan](https://github.com/CanCanCommunity/cancancan) [`Ability` classes](https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities). Written in pure Ruby with `cancancan` as its only dependency.

## Getting Started

### Motivations

CanCan's official documentation says that this is what your ability class should look like:

```ruby
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)
    if user.admin?
      can :manage, :all
    else
      can :read, :all
    end
  end
end
```

For small applications, this is simple and clear. However, in practice, some of these `Ability` classes are 200+ LoC monoliths that encompass the enforcement of many different kinds of permission sets without any clear separation of responsibility. 


### Quick Start

Specify a method on your domain object (for many, an `ActiveRecord` or `Mongoid` model, but any PORO is fine) returning an array of strings, one for each role. Warhol then takes those strings and matches them up to your defined ability classes. Here is a database-backed example inspired by the above snippet from CanCan's official docs:

First, some quick configuration. In a Rails project, we suggest this is placed in an initializer:

```ruby
require 'warhol'

Warhol::Config.new do |warhol|
  # This is the method we invoke below
  warhol.role_accessor = :role_names
end
```

The domain object can look like this: 

```ruby
class User << ActiveRecord::Base
  has_and_belongs_to_many :roles

  def role_names
    roles.pluck(:name)
  end
end
```

Some abilities:

```ruby
class Administrator < Warhol::Ability
  define_permissions do
    can :manage, :all

    # User is included in scope
    can :thing_with_condition, user_id: user.id
  end
end

class Member < Warhol::Ability
  define_permissions do
    can :read, :all
  end
end
```

Now, we just check the role. People using Rails can just invoke `can?` from their controller instead of explicitly making a new `Ability` class:
```
user
puts user.role_names
# => ['Member']
puts Ability.new(user).can? :manage, @something
# => false
```

That's it!

### Advanced Configuration Options

#### Map domain object to roles

Some elect to not store role data on user objects, but rather pass users to a service object that provides its authorization level. You can do this with Warhol by providing it with a `proc`:

```ruby
Warhol::Config.new do |warhol|
  warhol.role_proc = proc do |user|
    PermissionService.new(user).roles
  end
end
```

#### Override parent namespace of `Ability`

If for some reason you would like to bind `Ability` somewhere other than `Object::Ability`, you can provide an alternate namespace. 

```ruby
Warhol::Config.new do |warhol|
  warhol.ability_parent = Foo::Bar::Baz
end
```

`Foo::Bar::Baz::Ability` will now be where it is placed. 


## Copyright

Copyright (c) David Stancu 2017.

See {file:LICENSE.txt} for details.
