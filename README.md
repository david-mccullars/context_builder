# ContextBuilder

This gem provides a way of extending modules with context attributes.  Modules
that extend Context will receive the class method :context_attr which is
used to specify one or more context attributes that the extended module provides.
Each of these attributes will be accessible by name on classes that include the
extended module.  The value of that method is determined as the first non-nil
value from a hash provided to initialize_context or one of any number of lookup_NAME
methods in the class or any module included by the class.

## Installation

Add this line to your application's Gemfile:

    gem 'context_builder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install context_builder

## Example

   module Personage

     extend ContextBuilder

     context_attr :name, :age
     context_attr(:race) { |options| options[:race] || options[:ethnicity] }

     def lookup_age
       ENV['AGE']
     end

   end

   class User

     include Personage

     def initialize(name)
       initialize_context(:name => name, :ethnicity => 'unknown')
     end

     def lookup_age
       'N/A' unless name == 'Greg'
     end

   end

   User.new('Fred').inspect
   ### "#<User name=Fred age=N/A race=unknown>"

   ENV['AGE'] = '27'
   User.new('Greg').inspect
   ### "#<User name=Greg age=27 race=unknown>"

## Usage Notes

It is important to place 'extend Context' AFTER any self.included methods
defined on the extended module.  Otherwise, the self.included method will
overwrite the one from Context, rendering the 'extend' useless.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/context_builder/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
