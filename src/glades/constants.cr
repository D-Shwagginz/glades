module Glades
  module ControlConstants
    FORWARD     = Raylib::KeyboardKey::W
    BACKWARD    = Raylib::KeyboardKey::S
    RIGHT       = Raylib::KeyboardKey::D
    LEFT        = Raylib::KeyboardKey::A
    SENSITIVITY = 0.006
    INTERACT    = Raylib::KeyboardKey::E
  end

  module PlayerConstants
    PLAYER_SIZE       = Raylib::Vector2.new(x: 10, y: 10)
    WALK_SPEED        = 4.0_f32
    INTERACT_DISTANCE =       1
  end

  module PhysicsConstants
    COLLISION_PUSH_STRENGTH = 0.5
  end

  module GameConstants
    GLOBAL_SCALE   =  0.1
    LOCATION_SCALE =  0.1
    LIGHT_FALLOFF  = 0.08
    FONT_PATH      = "./rsrc/_dev/W95FA/W95FA.otf"
  end

  module HudConstants
    SCREEN_RES_X   = 2000
    SCREEN_RES_Y   = 1500
    VIEWPORT_RES_X =  600
    VIEWPORT_RES_Y =  300
  end
end
