module Rusty
  refine Object do
    def case
      Case.new(self)
    end
  end

  private

  class Case
    def initialize(value)
      @value = value
      @found = false
      @result = -> {}
    end

    def when(condition, &block)
      if !@found && condition === @value
        @found = true
        @result = block
      end
      self
    end

    def else(&block)
      if @found
        @result&.call(@value)
      else
        block&.call(@value)
      end
    end
  end
end
