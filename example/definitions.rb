#!/usr/bin/env ruby

# A demonstration of how to define classes, methods and aliases using rusty.

require_relative '../lib/rusty_key.rb'

RustyKey.using

:StringBuilder.class {
  :initialize.def { |*strs|
    @string = strs.join.dup
  }

  :<<.def { |*strs|
    @string << strs.join
    self
  }
  :append.alias :<<

  :to_s.def {
    @string.dup.freeze
  }
}

sb = StringBuilder.new("This ", "is ")
sb << "how "
sb.append("rusty_", "key ") << "works."

puts sb.to_s
#=> This is how rusty_key works.

