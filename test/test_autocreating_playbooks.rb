require "minitest/autorun"

require 'PlaybookGenerator'
require 'pry'

class ExamplePlaybookGen < Playbook
  def play

    playbook do
      step do
        name "sam"
        task do
          name "First task"
          shell "echo hi"
        end
        task do
          name "Second task"
          apt "name=nginx"
        end
      end

      step "Second" do
        serial 1
        task "Cobalt-blue" do
          shell "service FLCL start"
        end
      end
    end

  end
end

class ChildPlaybook < ExamplePlaybookGen
  def play
    playbook do
      step "sam" do
        serial 1
      end
    end
  end
end

class TestAutocreate < Minitest::Test
  def setup
    @play = ExamplePlaybookGen.new.compile_playbook
  end

  def test_playbook_hash_generate
    playbook = @play.to_hash
    assert playbook == [{"hosts"=>["all"], "name"=>"sam", "tasks"=>[{"shell"=>"echo hi", "name"=>"First task"}, {"apt"=>"name=nginx", "name"=>"Second task"}]},
                        {"serial"=>1, "hosts"=>["all"], "name"=>"Second", "tasks"=>[{"shell"=>"service FLCL start", "name"=>"Cobalt-blue"}]}]
  end

  def test_playbook_step_insertion
    @play.playbook do
      step "sam" do
        serial 2
      end
    end
    playbook = @play.to_hash
    assert playbook == [{"hosts"=>["all"], "name"=>"sam", "serial"=>2, "tasks"=>[{"shell"=>"echo hi", "name"=>"First task"}, {"apt"=>"name=nginx", "name"=>"Second task"}]},
                        {"serial"=>1, "hosts"=>["all"], "name"=>"Second", "tasks"=>[{"shell"=>"service FLCL start", "name"=>"Cobalt-blue"}]}]
  end

  def test_playbook_step_remove
    @play.playbook do
      step "sam" do
        remove
      end
    end
    playbook = @play.to_hash
    assert playbook == [{"serial"=>1, "hosts"=>["all"], "name"=>"Second", "tasks"=>[{"shell"=>"service FLCL start", "name"=>"Cobalt-blue"}]}]
  end

  def test_playbook_task_redefine_or_remove
    @play.playbook do
      step "sam" do
        task "First task" do
          shell "killall batman || echo 'why you wanna kill me?'"
        end
        task "Second task" do
          remove
        end
      end
    end
    playbook = @play.to_hash
    assert playbook == [{"hosts"=>["all"], "name"=>"sam", "tasks"=>[{"shell"=>"killall batman || echo 'why you wanna kill me?'", "name"=>"First task"}]},
                        {"serial"=>1, "hosts"=>["all"], "name"=>"Second", "tasks"=>[{"shell"=>"service FLCL start", "name"=>"Cobalt-blue"}]}]
  end

  def test_child_cookbok
    @child = ChildPlaybook.new
    playbook = @child.to_hash
    assert playbook == [{"serial"=>1, "hosts"=>["all"], "name"=>"sam", "tasks"=>[{"shell"=>"echo hi", "name"=>"First task"}, {"apt"=>"name=nginx", "name"=>"Second task"}]},
                        {"serial"=>1, "hosts"=>["all"], "name"=>"Second", "tasks"=>[{"shell"=>"service FLCL start", "name"=>"Cobalt-blue"}]}]
  end
end