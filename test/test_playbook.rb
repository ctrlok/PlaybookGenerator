require "minitest/autorun"
require 'PlaybookGenerator'
require 'pry'


class TestPlaybook < Minitest::Test
  def setup
    @playbook = PlaybookGenerator.new
  end

  def test_creating_step
    @playbook.step "Fist test step" do
      serial 1
    end
    step = @playbook.steps.first.to_s
    assert step == "Fist test step+++all+++"
  end

  def test_step_insert_after
    @playbook.step "First Step" do
    end
    @playbook.step "Third Step" do
    end
    @playbook.step "Second Step" do
      insert :after, "First Step"
    end
    step = @playbook.steps[1].to_s
    assert step == "Second Step+++all+++"
  end

  def test_step_insert_before
    @playbook.step "First Step" do
    end
    @playbook.step "Third Step" do

    end
    @playbook.step "Second Step" do
      insert :before, "First Step"
    end
    step = @playbook.steps[0].to_s
    assert step == "Second Step+++all+++"
  end

  def test_step_with_tasks
    @playbook.step "Test with tasks" do
      task "First task" do
        apt "test command"
        ansible_when "blabla"
      end
    end
    step = @playbook.steps.first.to_s
    assert step == "Test with tasks+++all+++First task"
  end

  def test_task_without_name
    @playbook.step do
      name "test step with task without name"
      task do
        apt 'test command'
      end
      task do
        apt 'second command'
      end
    end
    step = @playbook.steps.first.to_s
    assert step == "test step with task without name+++all+++apt: test command+++apt: second command"
  end
end