module Glades
  # Runs the program
  def self.run(start_map : MapFile = MapFile.new)
    @@start_map = start_map

    resx = 2000
    resy = 1500

    Raylib.init_window(resx, resy, "Glades")
    Raylib.set_window_state(Raylib::ConfigFlags::WindowResizable)
    Raylib.set_window_min_size(400, 300)
    Raylib.set_target_fps(60)

    Map.load(map_file: start_map)
    @@hud = Hud.new
    @@hud.as(Hud).load_viewport

    Glades.setup_shader

    until Raylib.close_window?
      if (
           Raylib.get_screen_width/Glades::HudConstants::SCREEN_RES_X <
             Raylib.get_screen_height/Glades::HudConstants::SCREEN_RES_Y
         )
        @@screen_scale = Raylib.get_screen_width/Glades::HudConstants::SCREEN_RES_X
      else
        @@screen_scale = (Raylib.get_screen_height/Glades::HudConstants::SCREEN_RES_Y).clamp(nil, 1.0)
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

    @@shaders.each do |shader|
      Raylib.unload_shader(shader)
    end

    @@textures.each do |tuple|
      Raylib.unload_texture(tuple[1])
    end

    if @@hud
      @@hud.as(Hud).unload_viewport
      Raylib.unload_render_texture(
        @@hud.as(Hud).hud_render_texture.as(Raylib::RenderTexture)
      )
    end

    Raylib.close_window
  end
end
