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
class Childd < ExamplePlaybookGen
  def play
    playbook do
      step "sam" do
        serial 1
      end
    end
  end
end

# playbook = ExamplePlaybookGen.new
# playbook.to_hash
playbook = Childd.new
playbook.to_hash
