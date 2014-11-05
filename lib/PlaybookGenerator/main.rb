require 'PlaybookGenerator/helpers/DSL'
class PlaybookGenerator
  attr_reader :steps
  include DSL::Steps
  def initialize(opts = {})
    @opts = opts
    @steps = YAMLArray.new
  end
  def step(step_name = nil, &block)
    @step = @steps.open(step_name) || PlaybookGenerator::Step.new(step_name)
    instance_eval &block
    insert(:last, @step) unless @steps.index(@step) if @step
  end
  def remove
    @steps.delete(@step)
    @step = nil
  end
  def task(task_name = nil, &block)
    @step.instance_eval do
      add_task(task_name, &block)
    end
  end
  def to_hash
    collection = Array.new
    for s in @steps
      collection.push(s.to_hash) if s
    end
    collection
  end

end

class PlaybookGenerator::Step
  include DSL::Tasks
  attr_writer :name
  attr_accessor :hosts, :serial, :tasks, :other
  def initialize(step_name)
    @hosts = ["all"]
    @name = step_name
    @tasks = YAMLArray.new
    @other = Hash.new
  end

  def add_task(task_name, &block)
    @task = @tasks.open(task_name) || PlaybookGenerator::Step::Task.new(task_name)
    @task.other = Hash.new
    instance_eval &block
    insert(:last, @task) unless @tasks.index(@task) if @task
  end
  def remove
    @tasks.delete(@task)
    @task = nil
  end
  def to_s
    [@name, @hosts.join("+++"), @tasks.join("+++")].join("+++")
  end
  def step_name
    @name
  end

  def to_hash
    collection = @other
    collection["hosts"] = @hosts
    collection["name"] = name
    collection["tasks"] = @tasks.map{|t| t.to_hash if t}
    collection
  end
end

class PlaybookGenerator::Step::Task
  attr_accessor :name, :command, :other
  def initialize(task_name)
    @name = task_name
    @other = Hash.new
  end
  def to_str
    @name
  end
  def to_hash
    if @other
      collection = @other
      collection["name"] = @name
      collection
    else
      nil
    end
  end
end

# TODO: Add hendlers (notify)
# TODO: Integrate with roles?

