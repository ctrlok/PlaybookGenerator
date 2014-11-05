class YAMLArray < Array
  insert_positions = [:before, :after, :last]
  insert_positions.each do |insert_position|
    define_method "insert_#{insert_position}" do |name,element|
      begin
        if insert_position == :last
          position = self.length
        else
          position = self.index{|v| v.name == name}
          raise FindElementException if position == nil
          position = position + 1 if insert_position == :after
        end
        self.insert(position, element)
      rescue FindElementException
        puts "Can't find element #{name} in array"
      end
    end
  end
  def open(name)
    position = self.index{|v| v.name  == name}
    self[position] if position
  end
  def remove(name)
    position = self.index{|v| v.name  == name}
    self.delete_at(position) if position
  end
end