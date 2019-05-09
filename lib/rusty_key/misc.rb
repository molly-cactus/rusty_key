module RustyKey
  refine Object do
    def return
      id = self.object_id
      binding.of_caller(1).eval("return ObjectSpace._id2ref(#{id})")
    end

    def yield
      b = binding.of_caller(1)
      # this is kinda hacky, but it is fun
      if b.local_variables.include? :block
        b.eval("block.call(#{self})")
      else
        b.eval("yield #{self}")
      end
    end
  end
end
