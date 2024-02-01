module Glades
  class Map
    class Door < Actor
      property size : Raylib::Vector3 = Raylib::Vector3.new
      property texture : Raylib::Texture2D = Raylib::Texture2D.new
      property file_path : String = ""
      property model : Raylib::Model = Raylib::Model.new

      property default_model_transform = Raylib::Matrix.new

      @moving = false
      @timer = false
      @open = false
      @time = 0.0
      @end_time = 0.0
      @current_rotation = 0.0

      # The speed the amount the door opens between each timer length
      @opening_speed = 200.0

      # The length of the delay before it rotates the door
      @timer_length = 0.01

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

      def interact
        @moving = true unless @moving
      end

      def update
        if @moving
          if @open
            # Close Door
            if @current_rotation > 0.0
              @time = Raylib.get_time

              unless @timer
                @timer = true
                @end_time = Raylib.get_time + @timer_length
              end

              if @time >= @end_time
                @current_rotation -= @opening_speed*Raylib.get_frame_time
                @model.transform = Raymath.matrix_multiply(@default_model_transform, Raymath.matrix_rotate_y(@current_rotation*Raylib::DEG2RAD))

                @timer = false
              end
            else
              @current_rotation = 0.0
              @model.transform = Raymath.matrix_multiply(@default_model_transform, Raymath.matrix_rotate_y(@current_rotation*Raylib::DEG2RAD))
              @open = false
              @moving = false
              @has_collision = true
            end
          else
            @has_collision = false
            # Open Door
            if @current_rotation < 90.0
              @time = Raylib.get_time

              unless @timer
                @timer = true
                @end_time = Raylib.get_time + @timer_length
              end

              if @time >= @end_time
                @current_rotation += @opening_speed*Raylib.get_frame_time
                @model.transform = Raymath.matrix_multiply(@default_model_transform, Raymath.matrix_rotate_y(@current_rotation*Raylib::DEG2RAD))

                @timer = false
              end
            else
              @current_rotation = 90.0
              @model.transform = Raymath.matrix_multiply(@default_model_transform, Raymath.matrix_rotate_y(@current_rotation*Raylib::DEG2RAD))
              @open = true
              @moving = false
            end
          end
        end
      end

      # Resets the bounding box to the location of the actor
      def reset_bounding_box
        @bounding_box = Raylib.get_model_bounding_box(@model)

        @bounding_box.max = @bounding_box.max*@size
        @bounding_box.min = @bounding_box.min*@size

        @bounding_box.max = @bounding_box.max + @location
        @bounding_box.min = @bounding_box.min + @location
      end

      def set_shader(shader : Raylib::Shader)
        material = Raylib::Material.new(
          shader: shader,
          maps: @model.materials[0].maps,
          params: @model.materials[0].params
        )

        Raylib.set_material_texture(pointerof(material), Raylib::MaterialMapIndex::Albedo, @texture)

        @model.materials[0] = material
      end

      def reset_texture
        if Glades.find_texture(@file_path + ".png")
          @texture = Glades.find_texture(@file_path + ".png").as(Tuple)[1]
        else
          Glades.load_texture(@file_path + ".png")
          @texture = Glades.find_texture(@file_path + ".png").as(Tuple)[1]
        end
      end

      def draw
        Raylib.draw_model_ex(@model, @location, Raylib::Vector3.new, 0, @size, Raylib::WHITE)
        Raylib.draw_bounding_box(@bounding_box, Raylib::RED)
      end

      def self.from_file(
        file : MapFile::Door,
        location : Raylib::Vector3 | MapFile::Vector3 = Raylib::Vector3.new,
        size : Raylib::Vector3 | MapFile::Vector3 = Raylib::Vector3.new
      )
        door = Door.new

        door.light_layer = file.light_layer

        Glades.light_layer_check(door.light_layer)

        location = Glades.mapfile_vector3_to_raylib(location) if location.is_a?(MapFile::Vector3)
        size = Glades.mapfile_vector3_to_raylib(size) if size.is_a?(MapFile::Vector3)

        door.location = (Raylib::Vector3.new(
          x: file.location.x,
          y: file.location.y,
          z: file.location.z
        ) + location) * GameConstants::GLOBAL_SCALE * size * GameConstants::LOCATION_SCALE

        door.size = (Raylib::Vector3.new(
          x: file.size.x,
          y: file.size.y,
          z: file.size.z
        ) * size) * GameConstants::GLOBAL_SCALE

        door.file_path = file.file_path

        door.reset_texture

        door.model = Raylib.load_model(door.file_path + ".iqm")

        door.default_model_transform = door.model.transform

        door.model.materials[0].maps[Raylib::MaterialMapIndex::Albedo.value].texture = door.texture

        door.reset_bounding_box
      end

      def destroy
        Glades.delete_actor(self)
      end
    end
  end
end
