module Glades
  @@actors : Array(Actor) = [] of Actor

  def self.add_actor(actor : Actor)
    @@actors << actor
  end

  def self.delete_actor(actor : Actor)
    @@actors.delete(actor)
  end

  @@player : Player | Nil
end
