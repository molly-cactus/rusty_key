# Rusty

This gem replaces many keywords with more-or-less equivalent method calls.

## Why?

I made a joke about Rust's proposed ["dot keyword" syntax](https://boats.gitlab.io/blog/post/await-decision/), namely that they should apply it to all their keywords.

Then I took that joke too far.

I have nothing but respect for the Rust Lang Team's work, and their proposal regarding the `await` keyword makes perfect sense to me. This is just a well-intentioned goof.

## Usage

Don't?

If you really want to, start with this:

```ruby
require 'rusty'

Rusty.using
```

Below are some things you can do, but it's probably not an exhaustive list. Consider using braces rather than `do` and `end` to heighten the effect.

# Define methods
```ruby
:foo.def { |x, y, *zs, key: value, &block|
  # stuff
}
```

# Define and monkey patch classes
```ruby
:Dog.class {
  :initialize.def { |color|
    # stuff
  }

  :bark.def {
    "wruff!"
  }
}

Dog.new(:green).bark # => "wruff!"
```

# Define and monkey patch modules
```ruby
:PrettyBow.module {
  # stuff
}
```
# using, alias, include, extend
```ruby
:Rusty.using
```
```ruby
:f.def { |x|
  # stuff
}
:func.alias :f
```
```ruby
:String.class {
  :Cheese.include
  :Kite.extend
}
```

# Flow control
```ruby
computation = -> { expensive() }
computation.if(necessary?)
  .else_if(cheap_check) { one_thing() }
  .elsif(-> { expensive_check }) { another_thing() }
  .else! { go_to_sleep() }
```

# Boolean logic
```ruby
false.or { true } # => true
false.and { expensive } # => false
```

# Case expressions
```ruby
x.case
  .when(String) { "It's a string!" }
  .when(0..10) { "Pretty small..." }
  .when(-> y { y.respond_to? :phone }) { "Hello? }
  .else { go_to_sleep() } 
```

# Raise and handle exceptions
```ruby
# raises RuntimeError, like `raise "msg"`
"something's wrong!".raise
```
```ruby
-> {
  ArgumentError.new("no arguing!").raise
}.rescue(OtherError, DifferentError) { |e|
  # not called
}.rescue(ArgumentError) { |e|
  puts "Please don't argue!"
}.rescue(Exception) { |e|
  # already caught, so this isn't called
}.ensure! {
  puts "Thank you for following the rules."
}
```

# return and yield
```ruby
:f.def { |x|
  -> { x / 3 }.return_if(x > 10) # guard clause
  (x * 3).return # explicit return
}
```
```ruby
:takes_block.def { |&block|
  25.yield # yields 25 to block
}
```

## Caveats

* Nested classes (and possibly other nested things) don't work.
* There's no replacement for `refine`.
* for `#elsif`/`#else_if`, wrap conditions in procs or they will always get evaluated.
* Specifically the class `Module` can't be monkey patched this way, or at least it couldn't at some point. Haven't tested that in a while.
* Speaking of which: There are no automated tests. I didn't think this would continue to the point where I might need them; I was wrong.
* Use return_if and return_unless for conditional returns (e.g. guard clauses) unless you're very comfortable with the difference in semantics between regular procs and lambdas.

## Acknowledgements

I'd like to thank:

* John Mair, whose [binding_of_caller gem](https://github.com/banister/binding_of_caller), released under the MIT license, makes most of this possible.
* The Rust Lang Team, who do great work and inspire terrible jokes.
* Matz, who will hopefully not ban me from using Ruby for releasing this.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/smoochbot/rusty. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Unlicense

This is free and unencumbered software released into the [public domain](http://unlicense.org).

## Code of Conduct

Everyone interacting in the Rusty project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/smoochbot/rusty/blob/master/CODE_OF_CONDUCT.md).
