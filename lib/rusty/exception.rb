require 'binding_of_caller'

module Rusty
  refine Exception do
    def raise
      id = self.object_id
      binding.of_caller(1).eval("raise ObjectSpace._id2ref(#{id})")
    end
  end

  refine String do
    def raise
      binding.of_caller(1).eval("raise \"#{self}\"")
    end
  end

  refine Proc do
    def rescue(*types, &handler)
      RescuedProc.new(self, *types, &handler)
    end
  end

  private

  class RescuedProc

    private

    attr_accessor :prc, :handlers, :otherwise, :finally, :result

    def merge_handlers(handler, *types, initial: handlers)
      # rescue clause with unspecified type handles StandardError
      types << StandardError if types.empty?
      types.reduce(initial) do |acc, k|
        # rescue clauses should be prioritized by order of declaration, desc
        acc.merge(k => handler) { |k, existing| existing }
      end
    end

    public

    def initialize(wrapped, *types, &handler)
      self.handlers = merge_handlers(handler, *types, initial: {})
      self.prc = wrapped
      self.result = nil
    end

    def rescue(*types, &handler)
      self.handlers = merge_handlers(handler, *types)
      self
    end

    def else(&handler)
      self.otherwise = handler
      self
    end

    def call
      begin
        self.result = prc.call
      rescue Exception => e
        if match = handlers.find { |type, handler| e.is_a? type }&.last
          match&.call(e)
        else
          raise e
        end
      else
        otherwise&.call
      ensure
        finally&.call
      end
      result
    end

    def to_proc
      -> { self.call }
    end

    def ensure(&handler)
      self.finally = handler
      self
    end

    def ensure!(&handler)
      self.ensure(&handler)
      self.call
    end
  end
end
