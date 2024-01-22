module Glades
  module ControlConstants
    FORWARD     = Raylib::KeyboardKey::W
    BACKWARD    = Raylib::KeyboardKey::S
    RIGHT       = Raylib::KeyboardKey::D
    LEFT        = Raylib::KeyboardKey::A
    SENSITIVITY = 0.01
  end

  module PlayerConstants
    PLAYER_SIZE = Raylib::Vector2.new(x: 10, y: 10)
  end

  module PhysicsConstants
    COLLISION_PUSH_STRENGTH = 0.5
  end

  module GameConstants
    GLOBAL_SCALE = 0.1
  end
end
