module Glades
  # Array of all actors created
  @@actors : Array(Actor) = [] of Actor

  # Adds an actor onto the `actors` array.
  # Used by the `Actor` class to add itself on initialize
  def self.add_actor(actor : Actor)
    @@actors << actor
  end

  # Removes an actor onto the `actors` array.
  # Used by the `Actor` class to remove itself on `Actor#destroy`
  def self.delete_actor(actor : Actor)
    @@actors.delete(actor)
  end

  # The main player
  @@player : Player | Nil
end
