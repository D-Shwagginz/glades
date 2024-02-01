module Glades
  # The player class
  class Player < Actor
    getter max_health : Float32 = 100.0
    getter health : Float32 = 100.0
    getter max_stamina : Float32 = 100.0
    getter stamina : Float32 = 100.0
    getter max_mana : Float32 = 100.0
    getter mana : Float32 = 100.0

    property movement_speed : Float32 = Glades::PlayerConstants::WALK_SPEED
    getter camera : Raylib::Camera = Raylib::Camera.new

    @camera_relative_location : Raylib::Vector3 = Raylib::Vector3.new

    # 0 = No Collision
    # 1 = "Pushes the player out in the direction from the collision_center to the player"
    # 2 = "Resets the player to the location before the collision"
    @collision_mode = 2
    @colliding : Bool = false
    @collision_mode_2_old_location : Raylib::Vector3 = Raylib::Vector3.new

    def initialize(
      @location : Raylib::Vector3 = Raylib::Vector3.new,
      @rotation : Raylib::Vector3 = Raylib::Vector3.new,
      @has_collision : Bool = true,
      @bounding_box_scale : Raylib::Vector3 = Raylib::Vector3.new
    )
      @bounding_box = Raylib::BoundingBox.new(
        min: Raylib::Vector3.new(x: @bounding_box_scale.x*0.5 + @location.x, y: @location.y, z: @bounding_box_scale.z*0.5 + @location.z),
        max: Raylib::Vector3.new(x: @bounding_box_scale.x*1.5 + @location.x, y: @bounding_box_scale.y + @location.y, z: @bounding_box_scale.z*1.5 + @location.z)
      )

      @camera_relative_location = Raylib::Vector3.new(
        x: (@bounding_box.max.x + @bounding_box.min.x)/2,
        y: (@bounding_box.max.y + @bounding_box.min.y)/1.15,
        z: (@bounding_box.max.z + @bounding_box.min.z)/2
      )

      # Glades.add_actor(self)

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
      @movement_speed = Glades::PlayerConstants::WALK_SPEED * Raylib.get_frame_time

      @health = @max_health if @health > @max_health
      @health = 0.0 if @health < 0.0

      # Match the bounding box to the player's movements
      @bounding_box = Raylib::BoundingBox.new(
        min: Raylib::Vector3.new(x: @bounding_box_scale.x*0.5 + @location.x, y: @location.y, z: @bounding_box_scale.z*0.5 + @location.z),
        max: Raylib::Vector3.new(x: @bounding_box_scale.x*1.5 + @location.x, y: @bounding_box_scale.y + @location.y, z: @bounding_box_scale.z*1.5 + @location.z)
      )

      if @collision_mode == 2
        # COLLISION SYSTEM 2 #
        if Glades.check_collisions(@bounding_box)
          # Resets the player to the location before the collision
          # Removes the relativity to the location
          @camera.target = @camera.target - @location

          @location = @collision_mode_2_old_location

          # Adds the location relativity back after updating the location
          @camera.target = @camera.target + @location

          @camera.position = @location + @camera_relative_location
        else
          # Sets the old player location for collision system 2
          @collision_mode_2_old_location = @location
        end
      end

      inputs

      Glades.check_collisions(self)
    end

    def collided(other_actor : Actor)
      @colliding = true

      # COLLISION SYSTEM 1 #
      # Pushes the player out in the direction from the collision_center to the player
      if @collision_mode == 1
        collision_center = (other_actor.bounding_box.max + other_actor.bounding_box.min)/2
        push_vector = Raymath.vector3_normalize(@location - collision_center)*PhysicsConstants::COLLISION_PUSH_STRENGTH

        @location = @location + push_vector
        @camera.position = @location + @camera_relative_location
        @camera.target = @camera.target + push_vector
      end
    end

    def draw
      Raylib.draw_bounding_box(@bounding_box, Raylib::RED)
    end

    def inputs
      move_forward_location = Raylib::Vector3.new(
        x: Glades.get_forward_vector(@rotation).x,
        z: Glades.get_forward_vector(@rotation).z
      ).scale(@movement_speed)

      move_right_location = Raylib::Vector3.new(
        x: Glades.get_right_vector(@rotation).x,
        z: Glades.get_right_vector(@rotation).z
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
      @rotation = @rotation + Raylib::Vector3.new(y: -Raylib.get_mouse_delta.x*ControlConstants::SENSITIVITY)*Raylib::RAD2DEG

      Raylib.camera_pitch(pointerof(@camera), -Raylib.get_mouse_delta.y*ControlConstants::SENSITIVITY, true, false, false)

      if Raylib.key_down?(ControlConstants::INTERACT)
        if Glades.what_looking_at
          Glades.what_looking_at.as(Actor).interact
        end
      end
    end
  end
end
