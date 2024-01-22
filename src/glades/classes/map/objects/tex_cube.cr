module Glades
  class Map
    class TexCube < Actor
      property size : Raylib::Vector3 = Raylib::Vector3.new
      property texture : Raylib::Texture2D = Raylib::Texture2D.new
      property texture_path : String = ""

      def initialize(
        @location : Raylib::Vector3 = Raylib::Vector3.new,
        @rotation : Raylib::Vector3 = Raylib::Vector3.new,
        @has_collision : Bool = true,
        @bounding_box_scale : Raylib::Vector3 = Raylib::Vector3.new
      )
        @bounding_box = Raylib::BoundingBox.new(
          min: Raylib::Vector3.new(x: (-@size.x)*0.5 + @location.x, y: @location.y, z: (-@size.z)*0.5 + @location.z),
          max: Raylib::Vector3.new(x: @size.x*0.5 + @location.x, y: @size.y + @location.y, z: @size.z*0.5 + @location.z)
        )

        Glades.add_actor(self)
      end

      # Resets the bounding box to the location of the actor
      def reset_bounding_box
        @bounding_box = Raylib::BoundingBox.new(
          min: Raylib::Vector3.new(x: (-@size.x)*0.5 + @location.x, y: @location.y, z: (-@size.z)*0.5 + @location.z),
          max: Raylib::Vector3.new(x: @size.x*0.5 + @location.x, y: @size.y + @location.y, z: @size.z*0.5 + @location.z)
        )
      end

      def reset_texture
        if Glades.find_texture(@texture_path)
          @texture = Glades.find_texture(@texture_path).as(Tuple)[1]
        else
          Glades.load_texture(@texture_path)
          @texture = Glades.find_texture(@texture_path).as(Tuple)[1]
        end
      end

      def draw
        Glades.draw_cube_texture(@texture, (@bounding_box.max + @bounding_box.min)/2, @size, Raylib::WHITE)
        Raylib.draw_bounding_box(@bounding_box, Raylib::RED)
      end

      def self.from_file(
        file : MapFile::TexCube,
        location : Raylib::Vector3 | MapFile::Vector3 = Raylib::Vector3.new,
        size : Raylib::Vector3 | MapFile::Vector3 = Raylib::Vector3.new
      )
        tex_cube = TexCube.new

        tex_cube.has_collision = file.has_collision

        location = Glades.mapfile_vector3_to_raylib(location) if location.is_a?(MapFile::Vector3)
        size = Glades.mapfile_vector3_to_raylib(size) if size.is_a?(MapFile::Vector3)

        tex_cube.location = (Raylib::Vector3.new(
          x: file.location.x,
          y: file.location.y,
          z: file.location.z
        ) + location) * GameConstants::GLOBAL_SCALE * size * GameConstants::LOCATION_SCALE

        tex_cube.size = (Raylib::Vector3.new(
          x: file.size.x,
          y: file.size.y,
          z: file.size.z
        ) * size) * GameConstants::GLOBAL_SCALE

        tex_cube.location = Raylib::Vector3.new(
          x: tex_cube.location.x + tex_cube.size.x/2,
          y: tex_cube.location.y,
          z: tex_cube.location.z + tex_cube.size.z/2)

        tex_cube.texture_path = file.texture_path

        tex_cube.reset_bounding_box
        tex_cube.reset_texture
      end
    end
  end
end
