module Glades
  # Draws the screen
  def self.draw
    Raylib.begin_drawing
    Raylib.clear_background(Raylib::RAYWHITE)
    unless @@player.nil?
      Raylib.begin_mode_3d(@@player.as(Player).camera)
      Raylib.draw_grid(10, 1.0)
      Raylib.end_mode_3d
    end
    Raylib.end_drawing
  end
end
