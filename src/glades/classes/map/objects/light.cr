module Glades
  class Map
    class Light < Actor
      property color : Raylib::Color = Raylib::Color.new
      property light : Glades::Light = Glades::Light.new

      def initialize(
        @location : Raylib::Vector3 = Raylib::Vector3.new,
        @rotation : Raylib::Vector3 = Raylib::Vector3.new,
        @has_collision : Bool = true,
        @bounding_box_scale : Raylib::Vector3 = Raylib::Vector3.new
      )
        @bounding_box = Raylib::BoundingBox.new

        @shadow_map = Raylib.load_render_texture(1024, 1024)

        Glades.add_light(self)
      end

      def load_light(shader : Raylib::Shader)
        @light = Lights.create(Lights::Type::Point, @location, Raylib::Vector3.new, @color, shader)
      end

      def draw
        Raylib.draw_cube_wires_v(@location, Raylib::Vector3.new(x: 0.4, y: 0.4, z: 0.4), Raylib::BLUE)
      end

      def self.from_file(
        file : MapFile::Light,
        location : Raylib::Vector3 | MapFile::Vector3 = Raylib::Vector3.new,
        size_offset : Raylib::Vector3 | MapFile::Vector3 = Raylib::Vector3.new
      )
        light = Light.new

        light.light_layer = file.light_layer

        Glades.light_layer_check(light.light_layer)

        location = Glades.mapfile_vector3_to_raylib(location) if location.is_a?(MapFile::Vector3)
        size_offset = Glades.mapfile_vector3_to_raylib(size_offset) if size_offset.is_a?(MapFile::Vector3)

        light.location = (Raylib::Vector3.new(
          x: file.location.x,
          y: file.location.y,
          z: file.location.z
        ) + location) * GameConstants::GLOBAL_SCALE * size_offset * GameConstants::LOCATION_SCALE

        light.color = Raylib::Color.new(
          r: file.color.x,
          g: file.color.y,
          b: file.color.z,
          a: 255
        )
      end
    end
  end
end
