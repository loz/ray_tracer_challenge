module Spectator
  alias TestMetaMethod = ::SpectatorTest, Example ->

  # Collection of hooks that run at various times throughout testing.
  # A hook is just a `Proc` (code block) that runs at a specified time.
  class ExampleHooks
    # Creates an empty set of hooks.
    # This will effectively run nothing extra while running a test.
    def self.empty
      new(
        [] of ->,
        [] of TestMetaMethod,
        [] of ->,
        [] of TestMetaMethod,
        [] of ::SpectatorTest, Proc(Nil) ->
      )
    end

    # Creates a new set of hooks.
    def initialize(
      @before_all : Array(->),
      @before_each : Array(TestMetaMethod),
      @after_all : Array(->),
      @after_each : Array(TestMetaMethod),
      @around_each : Array(::SpectatorTest, Proc(Nil) ->)
    )
    end

    # Runs all "before-all" hooks.
    # These hooks should be run once before all examples in the group start.
    def run_before_all
      @before_all.each &.call
    end

    # Runs all "before-each" hooks.
    # These hooks should be run every time before each example in a group.
    def run_before_each(wrapper : TestWrapper, example : Example)
      @before_each.each do |hook|
        wrapper.call(hook, example)
      end
    end

    # Runs all "after-all" hooks.
    # These hooks should be run once after all examples in group finish.
    def run_after_all
      @after_all.each &.call
    end

    # Runs all "after-all" hooks.
    # These hooks should be run every time after each example in a group.
    def run_after_each(wrapper : TestWrapper, example : Example)
      @after_each.each do |hook|
        wrapper.call(hook, example)
      end
    end

    # Creates a proc that runs the "around-each" hooks
    # in addition to a block passed to this method.
    # To call the block and all "around-each" hooks,
    # just invoke `Proc#call` on the returned proc.
    def wrap_around_each(test, block : ->)
      wrapper = block
      # Must wrap in reverse order,
      # otherwise hooks will run in the wrong order.
      @around_each.reverse_each do |hook|
        wrapper = wrap_foo(test, hook, wrapper)
      end
      wrapper
    end

    private def wrap_foo(test, hook, wrapper)
      ->{ hook.call(test, wrapper) }
    end
  end
end
