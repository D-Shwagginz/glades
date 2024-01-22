module Glades
  class Actor
    property location : Raylib::Vector3
    property rotation : Raylib::Vector3
    property has_collision : Bool
    getter bounding_box_scale : Raylib::Vector3
    getter bounding_box : Raylib::BoundingBox

    def initialize(
      @location : Raylib::Vector3 = Raylib::Vector3.new,
      @rotation : Raylib::Vector3 = Raylib::Vector3.new,
      @has_collision : Bool = true,
      @bounding_box_scale : Raylib::Vector3 = Raylib::Vector3.new
    )
      @bounding_box = Raylib::BoundingBox.new(
        min: Raylib::Vector3.new(x: (-@bounding_box_scale.x)*0.5 + @location.x, y: @location.y, z: (-@bounding_box_scale.z)*0.5 + @location.z),
        max: Raylib::Vector3.new(x: @bounding_box_scale.x*0.5 + @location.x, y: @bounding_box_scale.y + @location.y, z: @bounding_box_scale.z*0.5 + @location.z)
      )

      Glades.add_actor(self)
    end

    # Resets the bounding box to the location of the actor
    def reset_bounding_box
      @bounding_box = Raylib::BoundingBox.new(
        min: Raylib::Vector3.new(x: (-@bounding_box_scale.x)*0.5 + @location.x, y: @location.y, z: (-@bounding_box_scale.z)*0.5 + @location.z),
        max: Raylib::Vector3.new(x: @bounding_box_scale.x*0.5 + @location.x, y: @bounding_box_scale.y + @location.y, z: @bounding_box_scale.z*0.5 + @location.z)
      )
    end

    # The update code that is run by `Glades.update`
    # def update
    # end

    # The draw code that is run by `Glades.draw`
    # def draw
    # end

    # The collision code that is run by `Glades.check_collisions`
    # def collided(other_actor : Actor)
    # end

    def destroy
      Glades.delete_actor(self)
    end
  end
end
