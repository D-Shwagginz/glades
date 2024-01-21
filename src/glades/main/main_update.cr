module Glades
  # Updates the game
  def self.update
    # Updates each actor
    @@actors.each do |actor|
      if actor.responds_to?(:update)
        actor.update
      end
    end
  end
end
