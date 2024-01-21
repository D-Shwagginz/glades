module Glades
  class PlayerSpectator < Player
    property movement_speed : Float32 = 0.06
    getter camera : Raylib::Camera = Raylib::Camera.new

    def initialize(
      @location : Raylib::Vector3 = Raylib::Vector3.new,
      @rotation : Raylib::Vector3 = Raylib::Vector3.new,
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

      Glades.add_actor(self)

      @camera.position = @location + @camera_relative_location

      @camera.target = @camera.position + Raylib::Vector3.new(x: 0.0, y: 0.0, z: 1.0)

      @camera.up = Raylib::Vector3.new(x: 0.0, y: 1.0, z: 0.0)
      @camera.fovy = 45.0
      @camera.projection = Raylib::CameraProjection::Perspective

      Raylib.camera_pitch(pointerof(@camera), @rotation.x*Raylib::DEG2RAD, true, false, false)
      Raylib.camera_yaw(pointerof(@camera), (@rotation.y)*Raylib::DEG2RAD, false)
      Raylib.camera_roll(pointerof(@camera), @rotation.z*Raylib::DEG2RAD)
    end

    def update
      Raylib.update_camera(pointerof(@camera), Raylib::CameraMode::Free)
    end

    def collided(other_actor : Actor)
    end

    def inputs
    end
  end
end
