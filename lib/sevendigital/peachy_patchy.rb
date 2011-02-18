module Peachy
  class MethodName

    # let's also allow numbers and trailing underscores in element(method) names
    def matches_convention?
      @method_name =~ /^[a-z0-9]+(?:[_a-z0-9]+)*(?:NS[a-z0-9]+(?:[_a-z0-9]+)*)?$/
    end
  end
end
