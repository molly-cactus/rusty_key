module Rusty
  refine Symbol do
    def def(&b)
      binding.of_caller(1).eval('self').send(:define_method, self, b || -> {})
      self
    end

    def alias(original)
      binding.of_caller(1).eval("alias #{self} #{original}")
    end

    def include
      binding.of_caller(1).eval("include #{self}")
    end

    def extend
      binding.of_caller(1).eval("extend #{self}")
    end

    alias _class class
    def class(&b)
      return _class unless b
      # get context in which we're trying to define our class
      context = binding.of_caller(1).eval('self.class')
      # does a class with this name already exist?
      if context.const_defined?(self) &&
        context.const_get(self).is_a?(Class)
        # a class with this name does exist! we don't want to just replace it,
        # so let's get to monkey patching.
        context.const_get(self).class_eval(&b)
      else
        # there's no class with this name. there might be another constant,
        # but who cares? TODO: care
        context.const_set(self, Class.new(&b))
      end
      nil
    end
    alias Class class
    alias clazz Class
    alias klass Class

    def Module(&b)
      # get context in which we're trying to define our module
      context = binding.of_caller(1).eval('self.class')
      # does a module (not a class!) with this name already exist?
      if context.const_defined?(self) &&
          !context.const_get(self).is_a?(Class) &&
          context.const_get(self).is_a?(Module)
        # a module with this name does exist! we don't want to just replace it,
        # so let's get to monkey patching.
        context.const_get(self).module_eval(&b)
      else
        # there's no module with this name. there might be another constant,
        # but who cares? TODO: care
        context.const_set(self, Module.new(&b))
      end
      nil
    end
    alias module Module
  end

  refine Class do
    alias _class class
    def class(&b)
      b ? self.class_eval(&b) : _class
    end
    alias Class class
    alias clazz Class
    alias klass Class
  end

  refine Module do
    def Module(&b)
      self.module_eval(&b)
    end
    alias module Module

    alias _include include
    alias _extend extend

    def include(*args)
      if args.empty?
        binding.of_caller(1).eval("include #{self}")
      else
        _include(*args)
      end
    end

    def extend(*args)
      if args.empty?
        binding.of_caller(1).eval("extend #{self}")
      else
        _extend(*args)
      end
    end
  end
end
