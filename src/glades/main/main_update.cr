module Glades
  def self.update
    @@actors.each do |actor|
      if actor.responds_to?(:update)
        actor.update
      end
    end
    puts @@actors.size
  end
end
