module Glades
  # Draws the screen
  def self.draw
    unless @@hud.nil?
      # Draw onto the viewport
      if @@hud.as(Hud).viewport_render_texture
        Raylib.begin_texture_mode(@@hud.as(Hud).viewport_render_texture.as(Raylib::RenderTexture))
        Raylib.clear_background(Raylib::RAYWHITE)

        unless @@player.nil?
          Raylib.begin_mode_3d(@@player.as(Player).camera)
          Raylib.draw_grid(10, 1.0)

          # Draws each actor
          @@actors.each do |actor|
            if actor.responds_to?(:draw)
              actor.draw
            end
          end

          # Draws each light box
          @@lights.each do |light|
            light.draw
          end

          Raylib.end_mode_3d
        end

        Raylib.end_texture_mode
      end

      # Draw onto the hud
      if @@hud.as(Hud).hud_render_texture
        Raylib.begin_texture_mode(@@hud.as(Hud).hud_render_texture.as(Raylib::RenderTexture))
        Raylib.clear_background(Raylib::BLUE)
        @@hud.as(Hud).draw
        Raylib.end_texture_mode
      end

      # Draw onto the screen
      Raylib.begin_drawing
      Raylib.clear_background(Raylib::BLACK)
      @@hud.as(Hud).draw_screen
      Raylib.end_drawing
    end
  end
end
