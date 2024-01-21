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

  # Loaded textures
  @@textures : Array(Tuple(String, Raylib::Texture2D)) = [] of {String, Raylib::Texture2D}

  def self.load_texture(path : String | Path)
    image = Raylib.load_image(path)
    Raylib.image_rotate(pointerof(image), 180)
    texture = Raylib.load_texture_from_image(image)
    @@textures << {path, texture}
    Raylib.unload_image(image)
  end

  def self.find_texture(path : String | Path)
    @@textures.find { |tuple| tuple[0] == path }
  end
end
