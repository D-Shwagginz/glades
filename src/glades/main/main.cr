module Glades
  # Runs the program
  def self.run(start_map : MapFile = MapFile.new)
    @@start_map = start_map

    resx = 1600
    resy = 1200

    Raylib.init_window(resx, resy, "Glades")
    Raylib.set_target_fps(60)

    Map.load(map_file: start_map)

    # Load basic lighting shader
    @@shader = Raylib.load_shader("./rsrc/shaders/lighting.vs", "./rsrc/shaders/lighting.fs")

    # Get some required shader locations
    @@shader.locs[Raylib::ShaderLocationIndex::VectorView.value] = Raylib.get_shader_location(@@shader, "viewPos")
    # NOTE: "matModel" location name is automatically assigned on shader loading,
    # no need to get the location again if using that uniform name
    # @@shader.locs[Raylib::ShaderLocationIndex::MatrixModel.value] = Raylib.get_shader_location(@@shader, "matModel")

    # Ambient light level (some basic lighting)
    ambient_loc = Raylib.get_shader_location(@@shader, "ambient")
    Raylib.set_shader_value(@@shader, ambient_loc, LibC::Float[0.1, 0.1, 0.1, 1.0], Raylib::ShaderUniformDataType::Vec4.value)

    @@actors.each do |actor|
      if actor.responds_to?(:set_shader)
        actor.set_shader(@@shader)
      end
    end

    # Create lights
    @@lights << Lights.create(Lights::Type::Point, Raylib::Vector3.new(x: 0, y: 0, z: 0), Raylib::Vector3.new, Raylib::Color.new(r: 255, g: 10, b: 10), @@shader)

    until Raylib.close_window?
      # Player spawn test
      if Raylib.key_pressed?(Raylib::KeyboardKey::L)
        Raylib.disable_cursor
        @@player.as(Actor).destroy unless @@player.nil?
        @@player = Player.new(
          location: Raylib::Vector3.new(x: 0, y: 0, z: 0),
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

    Raylib.unload_shader(@@shader)

    @@textures.each do |tuple|
      Raylib.unload_texture(tuple[1])
    end

    Raylib.close_window
  end
end
