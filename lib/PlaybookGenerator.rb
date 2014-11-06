require 'PlaybookGenerator/main'
require 'yaml'
class Playbook
  def compile_playbook
    if self.class.superclass.instance_methods.include?(:play)
      @playbook = self.class.superclass.new.compile_playbook.playbook
    else
      @playbook ||= PlaybookGenerator.new
    end
    play
    self
  end
  def playbook(&block)
    @playbook.instance_eval &block if block_given?
    @playbook
  end
  def to_hash
    compile_playbook unless @playbook
    @playbook.to_hash
  end
  def to_yaml
    compile_playbook unless @playbook
    @playbook.to_hash.to_yaml
  end
end