module Glades
  # The player class
  class Player < Actor
    property movement_speed : Float32 = 0.01
    getter camera : Raylib::Camera = Raylib::Camera.new

    @camera_relative_location : Raylib::Vector3 = Raylib::Vector3.new

    def initialize(
      location : Raylib::Vector3 = Raylib::Vector3.new,
      rotation : Raylib::Vector3 = Raylib::Vector3.new,
      bounding_box_scale : Raylib::Vector3 = Raylib::Vector3.new
    )
      @location = location
      @rotation = rotation

      @bounding_box_scale = bounding_box_scale
      @bounding_box = Raylib::BoundingBox.new(
        min: Raylib::Vector3.new(x: @bounding_box_scale.x*0.5 + @location.x, y: @location.y, z: @bounding_box_scale.z*0.5 + @location.z),
        max: Raylib::Vector3.new(x: @bounding_box_scale.x*1.5 + @location.x, y: @bounding_box_scale.y + @location.y, z: @bounding_box_scale.z*1.5 + @location.z)
      )

      @camera_relative_location = Raylib::Vector3.new(
        x: (@bounding_box.max.x + @bounding_box.min.x)/2,
        y: (@bounding_box.max.y + @bounding_box.min.y)/1.15,
        z: (@bounding_box.max.z + @bounding_box.min.z)/2
      )

      Glades.add_actor(self)

      @camera.position = @location + @camera_relative_location

      @camera.target = @camera.position + Raylib::Vector3.new(x: 0.0, y: 0.0, z: 1.0)

      @camera.up = Raylib::Vector3.new(x: 0.0, y: 1.0, z: 0.0)
      @camera.fovy = 45.0
      @camera.projection = Raylib::CameraProjection::Perspective

      Raylib.update_camera(pointerof(@camera), Raylib::CameraMode::Custom)

      Raylib.camera_pitch(pointerof(@camera), @rotation.x*Raylib::DEG2RAD, true, false, false)
      Raylib.camera_yaw(pointerof(@camera), (@rotation.y)*Raylib::DEG2RAD, false)
      Raylib.camera_roll(pointerof(@camera), @rotation.z*Raylib::DEG2RAD)
    end

    def update
      # Match the bounding box to the player's movements
      @bounding_box = Raylib::BoundingBox.new(
        min: Raylib::Vector3.new(x: @bounding_box_scale.x*0.5 + @location.x, y: @location.y, z: @bounding_box_scale.z*0.5 + @location.z),
        max: Raylib::Vector3.new(x: @bounding_box_scale.x*1.5 + @location.x, y: @bounding_box_scale.y + @location.y, z: @bounding_box_scale.z*1.5 + @location.z)
      )

      inputs
    end

    def inputs
      move_forward_location = Raylib::Vector3.new(
        x: Glades.get_actor_forward_vector(self).x,
        z: Glades.get_actor_forward_vector(self).z
      ).scale(@movement_speed)

      move_right_location = Raylib::Vector3.new(
        x: Glades.get_actor_right_vector(self).x,
        z: Glades.get_actor_right_vector(self).z
      ).scale(@movement_speed)

      if Raylib.key_down?(ControlConstants::FORWARD)
        @location = @location + move_forward_location
        @camera.position = @location + @camera_relative_location
        @camera.target = @camera.target + move_forward_location
      end

      if Raylib.key_down?(ControlConstants::BACKWARD)
        @location = @location - move_forward_location
        @camera.position = @location + @camera_relative_location
        @camera.target = @camera.target - move_forward_location
      end

      if Raylib.key_down?(ControlConstants::RIGHT)
        @location = @location + move_right_location
        @camera.position = @location + @camera_relative_location
        @camera.target = @camera.target + move_right_location
      end

      if Raylib.key_down?(ControlConstants::LEFT)
        @location = @location - move_right_location
        @camera.position = @location + @camera_relative_location
        @camera.target = @camera.target - move_right_location
      end

      Raylib.camera_yaw(pointerof(@camera), -Raylib.get_mouse_delta.x*ControlConstants::SENSITIVITY, false)
      # @rotation = @rotation + Raylib::Vector3.new(y: -Raylib.get_mouse_delta.x*ControlConstants::SENSITIVITY)*Raylib::RAD2DEG
      print @rotation

      Raylib.camera_pitch(pointerof(@camera), -Raylib.get_mouse_delta.y*ControlConstants::SENSITIVITY, true, false, false)
    end
  end
end
