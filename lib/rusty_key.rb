require 'binding_of_caller'
require 'rusty_key/version'
require 'rusty_key/definition'
require 'rusty_key/case'
require 'rusty_key/boolean'
require 'rusty_key/exception'
require 'rusty_key/misc'

module RustyKey
end

## monkey-patching these to allow `RustyKey.using`

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

