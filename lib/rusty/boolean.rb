module Rusty
  refine Object do
    def and(condition)
      self && (condition.respond_to?(:call) ? condition.call : condition)
    end

    def or
      self || (condition.respond_to?(:call) ? condition.call : condition)
    end

    def if(condition)
      -> { self }.if(condition)
    end

    def unless(condition)
      -> { self }.unless(condition)
    end

    def if!(condition)
      self.if(condition).call
    end

    def unless!(condition)
      self.unless(condition).call
    end

    def return_if(condition)
      if condition
        result = self.if!(condition)
        id = result.object_id
        binding.of_caller(1).eval("return ObjectSpace._id2ref(#{id})")
      end
    end

    def return_unless(condition)
      unless condition
        result = self.unless!(condition)
        id = result.object_id
        binding.of_caller(1).eval("return ObjectSpace._id2ref(#{id})")
      end
    end
  end

  refine Proc do
    def if(condition)
      Conditional.if(self, condition)
    end

    def unless(condition)
      Conditional.unless(self, condition)
    end
  end

  private

  class Conditional
    private_class_method :new

    private

    def check(condition)
      if condition.respond_to?(:call)
        !!condition.call
      else
        !!condition
      end
    end

    attr_accessor :found, :result, :otherwise

    def initialize(action, negate, condition)
      self.found = negate ? !check(condition) : check(condition)
      self.result = found ? action : -> {}
    end

    public

    class << self
      def if(action, condition)
        new(action, false, condition)
      end
      def unless(action, condition)
        new(action, true, condition)
      end
    end

    def elsif(condition, &action)
      if !found && check(condition)
        self.found = true
        self.result = action
      end
      self
    end
    alias else_if elsif

    def call
      if found
        result&.call
      else
        otherwise&.call
      end
    end

    def else(&action)
      self.otherwise = action
      self
    end

    def else!(&action)
      self.else(&action)
      self.call
    end
  end
end
