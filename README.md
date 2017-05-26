# warhol

[![Code Climate](https://codeclimate.com/github/mach-kernel/warhol.png)](https://codeclimate.com/github/mach-kernel/warhol) ![CircleCI](https://circleci.com/gh/mach-kernel/warhol.svg?style=shield&circle-token=00f71ed6911aab669bda9ff2432ca6c66d54a5e0) [![Test Coverage](https://codeclimate.com/github/mach-kernel/warhol/badges/coverage.svg)](https://codeclimate.com/github/mach-kernel/warhol/coverage)

A better way to do [CanCanCan](https://github.com/CanCanCommunity/cancancan) [`Ability` classes](https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities). Written in pure Ruby with `cancancan` as its only dependency. Designed to improve code quality in existing projects with CanCan.

<img height="300px" src="https://raw.github.com/mach-kernel/warhol/master/splash.jpg" />

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

For small applications, this is simple and clear. However, in practice, some of these `Ability` classes are 200+ LoC monoliths that encompass the enforcement of many different kinds of permission sets without any clear separation of responsibility. Using `Warhol::Ability` allows you to have an individual set of permissions for each role in your domain.


### Quick Start

Specify a method on your domain object (for many, an `ActiveRecord` or `Mongoid` model, but any PORO is fine) returning an array of strings, one for each role. Warhol then takes those strings and matches them up to your defined ability classes, applying the access permissions you defined there. Matching is performed on the names of the `Warhol::Ability` subclass, excluding their namespaces. Here is a database-backed example inspired by the above snippet from CanCan's official docs:

First, some quick configuration. In a Rails project, we suggest this is placed in an initializer:

#### Initializer

```ruby
require 'warhol'

Warhol::Config.new do |warhol|
  # This is the method we invoke below
  warhol.role_accessor = :role_names

  # Exposes a basic attr_reader. More below.
  warhol.additional_accessors = ['user']
end
```

#### The Domain Object

The domain object can look like this: 

```ruby
class User << ActiveRecord::Base
  has_and_belongs_to_many :roles

  def role_names
    roles.pluck(:name)
  end
end
```

#### Definitions

Some abilities:

```ruby
class Administrator < Warhol::Ability
  define_permissions do
    can :manage, :all

    # object is always included in scope
    can :other_condition, user_id: object.id

    # user via additional accessor
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

### Config Options

To configure Warhol, we create a new singleton configuration class. Every time you invoke `::new`, the instance is replaced with the one you most recently defined. 

```ruby
Warhol::Config.new do |warhol|
  warhol.option = value
end
```
| Key                      | Type          | Description                                                                                                                                                                                                                                           |
|--------------------------|---------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| ability_parent           | Module        | The parent object under which to define the `Ability` constant.                                                                                                                                                                                       |
| additional_accessors     | Array[String] | By default, inside the `define_permissions` block you can access the object you are performing the check on by invoking `object`. For the example use case of applying user permissions, passing `%w(user)` may not be a bad idea.                    |
| role_accessor (REQUIRED) | Symbol        | Accessor used to fetch roles from domain object.                                                                                                                                                                                                      |
| role_proc                | Proc          | If you do not wish to define an accessor, you can pass a block with an arity of 1; the object you are performing the check against will be passed as an argument allowing you to either implement the logic here or delegate it to a service object.  |


### Advanced Usage

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


## License

MIT License

Copyright (c) 2017 David Stancu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
