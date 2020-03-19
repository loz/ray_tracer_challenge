require "../spectator_test"
require "./source"

module Spectator
  alias TestMethod = ::SpectatorTest ->

  # Stores information about a end-user test.
  # Used to instantiate tests and run them.
  struct TestWrapper
    # Description the user provided for the test.
    def description
      @description || @source.to_s
    end

    # Location of the test in source code.
    getter source

    # Creates a wrapper for the test.
    def initialize(@description : String?, @source : Source, @test : ::SpectatorTest, @runner : TestMethod)
    end

    def description?
      !@description.nil?
    end

    def run
      call(@runner)
    end

    def call(method : TestMethod) : Nil
      method.call(@test)
    end

    def call(method, *args) : Nil
      method.call(@test, *args)
    end

    def around_hook(context : TestContext)
      context.wrap_around_each_hooks(@test) { run }
    end
  end
end
