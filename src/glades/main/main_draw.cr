module Glades
  # Draws the screen
  def self.draw
    Raylib.begin_drawing
    # Raylib.begin_shader_mode(@@shader)
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

    # Raylib.end_shader_mode
    Raylib.end_drawing
  end
end
