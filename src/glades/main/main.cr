module Glades
  # Runs the program
  def self.run(start_map : MapFile = MapFile.new)
    @@start_map = start_map

    resx = 1600
    resy = 1200

    Raylib.init_window(resx, resy, "Glades")
    Raylib.set_target_fps(60)

    Map.load(map_file: start_map)

    until Raylib.close_window?
      # Player spawn test
      if Raylib.key_pressed?(Raylib::KeyboardKey::L)
        Raylib.disable_cursor
        @@player.as(Actor).destroy unless @@player.nil?
        @@player = Player.new(
          bounding_box_scale: Raylib::Vector3.new(x: 0.5, y: 1, z: 0.5)
        )
      end

      if Raylib.key_pressed?(Raylib::KeyboardKey::P)
        Raylib.disable_cursor
        @@player.as(Actor).destroy unless @@player.nil?
        @@player = PlayerSpectator.new(
          bounding_box_scale: Raylib::Vector3.new(x: 0.5, y: 1, z: 0.5)
        )
      end

      update
      draw
    end

    @@textures.each do |tuple|
      Raylib.unload_texture(tuple[1])
    end

    Raylib.close_window
  end
end
