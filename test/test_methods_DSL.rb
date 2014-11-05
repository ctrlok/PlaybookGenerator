require "minitest/autorun"
require 'PlaybookGenerator'
require 'PlaybookGenerator/helpers/ansible_methods'
require 'pry'

class TestMethodsDSL < Minitest::Test
  include AnsibleMethods::Step
  include AnsibleMethods::Task

  def setup
    @playbook = PlaybookGenerator.new
  end
  ANSIBLE_STEP_METHODS.each do |method|
    define_method("test_#{method}") do
      @playbook.step "Step" do
        self.send(method, "TestValue")
      end
      assert @playbook.steps.first.other[method.to_s] = "TestValue"
    end
  end
  ANSIBLE_COMMAND_METHODS.each do |method|
    define_method("test_#{method}") do
      @playbook.step "Step" do
        task "TestTask" do
          self.send(method, "TestValue")
        end
      end
      @playbook
      assert @playbook.steps.first.tasks.first.other[method.to_s] = "TestValue"
    end
  end
  ANSIBLE_TASK_METHODS.each do |method|
    define_method("test_#{method}") do
      @playbook.step "Step" do
        task "TestTask" do
          self.send(method, "TestValue")
        end
      end
      @playbook
      assert @playbook.steps.first.tasks.first.other[method.to_s] = "TestValue"
    end
  end

end