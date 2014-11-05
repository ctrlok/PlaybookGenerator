require 'PlaybookGenerator/main'
require 'yaml'
class Playbook
  def initialize
    if self.class.superclass.instance_methods.include?(:play)
      @playbook = self.class.superclass.new.playbook
    else
      @playbook ||= PlaybookGenerator.new
    end
    play
  end
  def playbook(&block)
    @playbook.instance_eval &block if block_given?
    @playbook
  end
  def to_hash
    @playbook.to_hash
  end
  def to_yaml
    @playbook.to_hash.to_yaml
  end
end