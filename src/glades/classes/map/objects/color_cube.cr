module Glades
  class Map
    class ColorCube < Actor
      property size : Raylib::Vector3 = Raylib::Vector3.new
      property color : Raylib::Color = Raylib::Color.new
      property model : Raylib::Model = Raylib::Model.new

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

      def set_shader(shader : Raylib::Shader)
        @model.materials[0] = Raylib::Material.new(
          shader: shader,
          maps: @model.materials[0].maps,
          params: @model.materials[0].params
        )
      end

      def draw
        Raylib.draw_model(@model, (@bounding_box.max + @bounding_box.min)/2, 1, @color)
        # Raylib.draw_cube_v((@bounding_box.max + @bounding_box.min)/2, @size, @color)
        Raylib.draw_bounding_box(@bounding_box, Raylib::RED)
      end

      def self.from_file(
        file : MapFile::ColorCube,
        location : Raylib::Vector3 | MapFile::Vector3 = Raylib::Vector3.new,
        size : Raylib::Vector3 | MapFile::Vector3 = Raylib::Vector3.new
      )
        color_cube = ColorCube.new

        color_cube.light_layer = file.light_layer

        Glades.light_layer_check(color_cube.light_layer)

        color_cube.has_collision = file.has_collision

        location = Glades.mapfile_vector3_to_raylib(location) if location.is_a?(MapFile::Vector3)
        size = Glades.mapfile_vector3_to_raylib(size) if size.is_a?(MapFile::Vector3)

        color_cube.location = (Raylib::Vector3.new(
          x: file.location.x,
          y: file.location.y,
          z: file.location.z
        ) + location) * GameConstants::GLOBAL_SCALE * size * GameConstants::LOCATION_SCALE

        color_cube.size = (Raylib::Vector3.new(
          x: file.size.x,
          y: file.size.y,
          z: file.size.z
        ) * size) * GameConstants::GLOBAL_SCALE

        color_cube.location = Raylib::Vector3.new(
          x: color_cube.location.x + color_cube.size.x/2,
          y: color_cube.location.y,
          z: color_cube.location.z + color_cube.size.z/2)

        color_cube.color = Raylib::Color.new(
          r: file.color.x,
          g: file.color.y,
          b: file.color.z,
          a: 255
        )

        mesh = Raylib.gen_mesh_cube(color_cube.size.x, color_cube.size.y, color_cube.size.z)
        color_cube.model = Raylib.load_model_from_mesh(mesh)

        color_cube.reset_bounding_box
      end

      def destroy
        Raylib.unload_model(@model)
        Glades.delete_actor(self)
      end
    end
  end
end
