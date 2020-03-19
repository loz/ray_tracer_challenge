require "../test_values"
require "./example_group_builder"

module Spectator::SpecBuilder
  class RootExampleGroupBuilder < ExampleGroupBuilder
    def build
      context = TestContext.new(nil, build_hooks, build_conditions, TestValues.empty, {} of String => Deque(Mocks::MethodStub))
      RootExampleGroup.new(context).tap do |group|
        group.children = children.map do |child|
          child.build(group).as(ExampleComponent)
        end
      end
    end
  end
end
