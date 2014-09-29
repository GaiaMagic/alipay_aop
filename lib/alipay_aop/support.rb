
module AlipayAOP
  class NoInstanceVariableError < NameError; end

  module Support

    def instance_variable_present?(arg)
      !!self.instance_variable_get "@#{arg.to_s}"
    end

  end
end
