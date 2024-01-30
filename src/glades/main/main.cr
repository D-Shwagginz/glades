module Glades
  # Runs the program
  def self.run(start_map : MapFile = MapFile.new)
    @@start_map = start_map

    resx = 1920
    resy = 1080

    Raylib.init_window(resx, resy, "Glades")
    Raylib.set_window_state(Raylib::ConfigFlags::WindowResizable)
    Raylib.set_window_min_size(400, 300)
    Raylib.set_target_fps(60)

    @@font = Raylib.load_font(Glades::GameConstants::FONT_PATH)

    Map.load(map_file: start_map)
    @@hud = Hud.new
    @@hud.as(Hud).load

    Glades.setup_shader

    until Raylib.close_window?
      if (
           Raylib.get_screen_width/Glades::HudConstants::SCREEN_RES_X <
             Raylib.get_screen_height/Glades::HudConstants::SCREEN_RES_Y
         )
        @@screen_scale = Raylib.get_screen_width/Glades::HudConstants::SCREEN_RES_X
      else
        @@screen_scale = Raylib.get_screen_height/Glades::HudConstants::SCREEN_RES_Y
      end

      # Player spawn test
      if Raylib.key_pressed?(Raylib::KeyboardKey::L)
        # Raylib.disable_cursor
        @@player.as(Actor).destroy unless @@player.nil?
        @@player = Player.new(
          location: Raylib::Vector3.new(x: 0, y: 0, z: 0),
          bounding_box_scale: Raylib::Vector3.new(x: 0.5, y: 1, z: 0.5)
        )
      end

      if Raylib.key_pressed?(Raylib::KeyboardKey::P)
        # Raylib.disable_cursor
        @@player.as(Actor).destroy unless @@player.nil?
        @@player = PlayerSpectator.new(
          bounding_box_scale: Raylib::Vector3.new(x: 0.5, y: 1, z: 0.5)
        )
      end

      update
      draw
    end

    Raylib.unload_font(@@font)

    @@shaders.each do |shader|
      Raylib.unload_shader(shader)
    end

    @@textures.each do |tuple|
      Raylib.unload_texture(tuple[1])
    end

    if @@hud
      @@hud.as(Hud).unload
    end

    Raylib.close_window
  end
end
