require 'PlaybookGenerator/helpers/array'
require 'PlaybookGenerator/helpers/ansible_methods'
module DSL
  module Steps
    include AnsibleMethods::Step
    #TODO: add vars as step (array) method
    ANSIBLE_STEP_METHODS.each do |method|
      define_method(method) do |command|
        @step.other[method.to_s] = command
      end
    end

    def hosts(hosts)
      @step.hosts = Array(hosts)
    end
    def insert(insert_position, step_name)
    @steps.public_send("insert_#{insert_position}", *[step_name, @step])
      @steps
    end
    def name(step_name = nil)
      @step.name = step_name if step_name
      @step.step_name
    end

  end
  module Tasks
    include AnsibleMethods::Task
    ANSIBLE_COMMAND_METHODS.each do |method|
      define_method(method) do |command|
        @task.other[method.to_s] = command
        @task.name ||= "#{method.to_s}: #{command}"
      end
    end
    ANSIBLE_TASK_METHODS.each do |method|
      define_method(method) do |command|
        @task.other[method.to_s] = command
      end
    end
    ansible_task_rewrited = [:when]
    ansible_task_rewrited.each do |method|
      define_method("ansible_#{method}") do |command|
        @task.other[method.to_s] = command
      end
    end

    def insert(insert_position, task_name)
      @tasks.public_send("insert_#{insert_position}", *[task_name, @task])
      @tasks
    end
    def name(task_name = nil)
      @task.name = task_name if task_name
      self.step_name
    end

  end


end

