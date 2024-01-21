module Glades
  class Map
    class ColorCube < Actor
      property size : Raylib::Vector3 = Raylib::Vector3.new
      property color : Raylib::Color = Raylib::Color.new

      def initialize(
        @location : Raylib::Vector3 = Raylib::Vector3.new,
        @rotation : Raylib::Vector3 = Raylib::Vector3.new,
        @bounding_box_scale : Raylib::Vector3 = Raylib::Vector3.new
      )
        @bounding_box = Raylib::BoundingBox.new(
          min: Raylib::Vector3.new(x: @size.x*0.5 + @location.x, y: @location.y, z: @size.z*0.5 + @location.z),
          max: Raylib::Vector3.new(x: @size.x*1.5 + @location.x, y: @size.y + @location.y, z: @size.z*1.5 + @location.z)
        )

        Glades.add_actor(self)
      end

      def reset_bounding_box
        @bounding_box = Raylib::BoundingBox.new(
          min: Raylib::Vector3.new(x: @size.x*0.5 + @location.x, y: @location.y, z: @size.z*0.5 + @location.z),
          max: Raylib::Vector3.new(x: @size.x*1.5 + @location.x, y: @size.y + @location.y, z: @size.z*1.5 + @location.z)
        )
      end

      def draw
        Raylib.draw_cube_v((@bounding_box.max + @bounding_box.min)/2, @size, @color)
        Raylib.draw_bounding_box(@bounding_box, Raylib::RED)
      end

      def self.from_file(file : MapFile::ColorCube)
        color_cube = ColorCube.new

        color_cube.location = Raylib::Vector3.new(
          x: file.location.x,
          y: file.location.y,
          z: file.location.z
        )

        color_cube.size = Raylib::Vector3.new(
          x: file.size.x,
          y: file.size.y,
          z: file.size.z
        )

        color_cube.color = Raylib::Color.new(
          r: file.color.x,
          g: file.color.y,
          b: file.color.z,
          a: 255
        )

        color_cube.reset_bounding_box
      end
    end
  end
end
