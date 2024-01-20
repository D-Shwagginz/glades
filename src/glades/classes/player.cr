module Glades
  # The player class
  class Player < Actor
    property movement_speed : Float32 = 0.01
    getter camera : Raylib::Camera = Raylib::Camera.new

    @camera_relative_location : Raylib::Vector3 = Raylib::Vector3.new

    def initialize(
      location : Raylib::Vector3 = Raylib::Vector3.new,
      rotation : Raylib::Vector3 = Raylib::Vector3.new
    )
      @location = location
      @rotation = rotation
      Glades.add_actor(self)

      @camera.position = @location + @camera_relative_location

      @camera.target = @camera.position + Raylib::Vector3.new(x: 0.0, y: 0.0, z: 1.0)

      @camera.up = Raylib::Vector3.new(x: 0.0, y: 1.0, z: 0.0)
      @camera.fovy = 45.0
      @camera.projection = Raylib::CameraProjection::Perspective

      Raylib.update_camera(pointerof(@camera), Raylib::CameraMode::Custom)

      Raylib.camera_pitch(pointerof(@camera), @rotation.x*Raylib::DEG2RAD, true, false, false)
      Raylib.camera_yaw(pointerof(@camera), @rotation.y*Raylib::DEG2RAD, false)
      Raylib.camera_roll(pointerof(@camera), @rotation.z*Raylib::DEG2RAD)
    end

    def update
      inputs
    end

    def inputs
      move_forward_location = Raylib::Vector3.new(
        x: Raylib.get_camera_forward(pointerof(@camera)).x,
        z: Raylib.get_camera_forward(pointerof(@camera)).z
      ).scale(@movement_speed)

      move_right_location = Raylib::Vector3.new(
        x: Raylib.get_camera_right(pointerof(@camera)).x,
        z: Raylib.get_camera_right(pointerof(@camera)).z
      ).scale(@movement_speed)

      if Raylib.key_down?(ControlConstants::FORWARD)
        @location = @location + move_forward_location
        @camera.position = @location + @camera_relative_location
        @camera.target = @camera.target + move_forward_location + @camera_relative_location
      end

      if Raylib.key_down?(ControlConstants::BACKWARD)
        @location = @location - move_forward_location
        @camera.position = @location + @camera_relative_location
        @camera.target = @camera.target - move_forward_location + @camera_relative_location
      end

      if Raylib.key_down?(ControlConstants::RIGHT)
        @location = @location + move_right_location
        @camera.position = @location + @camera_relative_location
        @camera.target = @camera.target + move_right_location + @camera_relative_location
      end

      if Raylib.key_down?(ControlConstants::LEFT)
        @location = @location - move_right_location
        @camera.position = @location + @camera_relative_location
        @camera.target = @camera.target - move_right_location + @camera_relative_location
      end

      Raylib.camera_yaw(pointerof(@camera), -Raylib.get_mouse_delta.x*ControlConstants::SENSITIVITY, false)
      Raylib.camera_pitch(pointerof(@camera), -Raylib.get_mouse_delta.y*ControlConstants::SENSITIVITY, true, false, false)
    end
  end
end
