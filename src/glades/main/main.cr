module Glades
  # Runs the program
  def self.run
    resx = 1600
    resy = 1200

    Raylib.init_window(resx, resy, "Glades")
    Raylib.set_target_fps(60)
    model = Raylib.load_model("./rsrc/testmap.obj")
    map = Map.new(
      model: model
    )

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
