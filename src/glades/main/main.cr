module Glades
  # Runs the program
  def self.run
    resx = 1024
    resy = 768

    Raylib.init_window(resx, resy, "Glades")
    Raylib.set_target_fps(60)

    until Raylib.close_window?
      # Player spawn test
      if Raylib.key_pressed?(Raylib::KeyboardKey::L)
        @@player.as(Actor).destroy unless @@player.nil?
        @@player = Player.new(
          location: Raylib::Vector3.new(y: 0),
          bounding_box_scale: Raylib::Vector3.new(x: 0.5, y: 1, z: 0.5)
        )
      end

      update
      draw
    end

    Raylib.close_window
  end
end
