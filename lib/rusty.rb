require 'binding_of_caller'
require 'rusty/version'
require 'rusty/definition'
require 'rusty/case'
require 'rusty/boolean'
require 'rusty/exception'
require 'rusty/misc'

module Rusty
end

## monkey-patching these to allow `Rusty.using`

class Symbol
  def using
    b = binding.of_caller(1)
    b.eval("using #{self}")
    b
  end
end

class Module
  def using
    b = binding.of_caller(1)
    b.eval("using #{self}")
    b
  end
end

