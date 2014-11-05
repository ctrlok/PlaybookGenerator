require 'PlaybookGenerator'
require 'pry'
class ExamplePlaybookGen < Playbook
  def play
    playbook do
      step do
        name "sam"
      end
    end
  end
end

playbook = ExamplePlaybookGen.new
playbook