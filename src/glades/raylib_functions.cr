module Glades
  struct Light
    property type : Lights::Type = Lights::Type::Point
    property position : Raylib::Vector3 = Raylib::Vector3.new
    property target : Raylib::Vector3 = Raylib::Vector3.new
    property color : Raylib::Color = Raylib::Color.new
    property enabled : Bool = false

    property enabled_loc : LibC::Int = 0
    property type_loc : LibC::Int = 0
    property pos_loc : LibC::Int = 0
    property target_loc : LibC::Int = 0
    property color_loc : LibC::Int = 0
  end

  module Lights
    MAX = 4

    class_getter count = 0

    enum Type
      Directional
      Point
    end

    def self.create(type : Type, position : Raylib::Vector3, target : Raylib::Vector3, color : Raylib::Color, shader : Raylib::Shader) : Light
      light = Light.new

      if @@count < MAX
        light.enabled = true
        light.type = type
        light.position = position
        light.target = target
        light.color = color

        light.enabled_loc = Raylib.get_shader_location(shader, "lights[#{@@count}].enabled")
        light.type_loc = Raylib.get_shader_location(shader, "lights[#{@@count}].type")
        light.pos_loc = Raylib.get_shader_location(shader, "lights[#{@@count}].position")
        light.target_loc = Raylib.get_shader_location(shader, "lights[#{@@count}].target")
        light.color_loc = Raylib.get_shader_location(shader, "lights[#{@@count}].color")

        update(shader, light)
        @@count += 1
      else
        raise "Too many lights!"
      end

      return light
    end

    def self.update(shader : Raylib::Shader, light : Light)
      enabled = light.enabled.to_unsafe
      Raylib.set_shader_value(shader, light.enabled_loc, pointerof(enabled), Raylib::ShaderUniformDataType::Int)

      value = light.type.value
      Raylib.set_shader_value(shader, light.type_loc, pointerof(value), Raylib::ShaderUniformDataType::Int)

      Raylib.set_shader_value(shader, light.pos_loc, LibC::Float[light.position.x, light.position.y, light.position.z], Raylib::ShaderUniformDataType::Vec3)
      Raylib.set_shader_value(shader, light.target_loc, LibC::Float[light.target.x, light.target.y, light.target.z], Raylib::ShaderUniformDataType::Vec3)
      Raylib.set_shader_value(shader, light.color_loc, LibC::Float[
        light.color.r/255.0_f32,
        light.color.g/255.0_f32,
        light.color.b/255.0_f32,
        light.color.a/255.0_f32,
      ], Raylib::ShaderUniformDataType::Vec4)
    end
  end

  def self.draw_cube_texture(texture : Raylib::Texture2D, position : Raylib::Vector3, size : Raylib::Vector3, color : Raylib::Color)
    x = position.x
    y = position.y
    z = position.z

    width = size.x
    height = size.y
    length = size.z

    # Set desired texture to be enabled while drawing following vertex data
    RLGL.set_texture(texture.id)

    # Vertex data transformation can be defined with the commented lines,
    # but in this example we calculate the transformed vertex data directly when calling RLGL.vertex_3f()
    # rlPushMatrix()
    # NOTE: Transformation is applied in inverse order (scale -> rotate -> translate)
    # rlTranslatef(2.0, 0.0, 0.0)
    # rlRotatef(45, 0, 1, 0)
    # rlScalef(2.0, 2.0, 2.0)

    RLGL.begin(RLGL::QUADS)
    RLGL.color_4ub(color.r, color.g, color.b, 255)
    # Front Face
    RLGL.normal_3f(0.0, 0.0, 1.0) # Normal Pointing Towards Viewer
    RLGL.texcoord_2f(0.0, 0.0)
    RLGL.vertex_3f(x - width/2, y - height/2, z + length/2) # Bottom Left Of The Texture and Quad
    RLGL.texcoord_2f(1.0, 0.0)
    RLGL.vertex_3f(x + width/2, y - height/2, z + length/2) # Bottom Right Of The Texture and Quad
    RLGL.texcoord_2f(1.0, 1.0)
    RLGL.vertex_3f(x + width/2, y + height/2, z + length/2) # Top Right Of The Texture and Quad
    RLGL.texcoord_2f(0.0, 1.0)
    RLGL.vertex_3f(x - width/2, y + height/2, z + length/2) # Top Left Of The Texture and Quad
    # Back Face
    RLGL.normal_3f(0.0, 0.0, -1.0) # Normal Pointing Away From Viewer
    RLGL.texcoord_2f(1.0, 0.0)
    RLGL.vertex_3f(x - width/2, y - height/2, z - length/2) # Bottom Right Of The Texture and Quad
    RLGL.texcoord_2f(1.0, 1.0)
    RLGL.vertex_3f(x - width/2, y + height/2, z - length/2) # Top Right Of The Texture and Quad
    RLGL.texcoord_2f(0.0, 1.0)
    RLGL.vertex_3f(x + width/2, y + height/2, z - length/2) # Top Left Of The Texture and Quad
    RLGL.texcoord_2f(0.0, 0.0)
    RLGL.vertex_3f(x + width/2, y - height/2, z - length/2) # Bottom Left Of The Texture and Quad
    # Top Face
    RLGL.normal_3f(0.0, 1.0, 0.0) # Normal Pointing Up
    RLGL.texcoord_2f(0.0, 1.0)
    RLGL.vertex_3f(x - width/2, y + height/2, z - length/2) # Top Left Of The Texture and Quad
    RLGL.texcoord_2f(0.0, 0.0)
    RLGL.vertex_3f(x - width/2, y + height/2, z + length/2) # Bottom Left Of The Texture and Quad
    RLGL.texcoord_2f(1.0, 0.0)
    RLGL.vertex_3f(x + width/2, y + height/2, z + length/2) # Bottom Right Of The Texture and Quad
    RLGL.texcoord_2f(1.0, 1.0)
    RLGL.vertex_3f(x + width/2, y + height/2, z - length/2) # Top Right Of The Texture and Quad
    # Bottom Face
    RLGL.normal_3f(0.0, -1.0, 0.0) # Normal Pointing Down
    RLGL.texcoord_2f(1.0, 1.0)
    RLGL.vertex_3f(x - width/2, y - height/2, z - length/2) # Top Right Of The Texture and Quad
    RLGL.texcoord_2f(0.0, 1.0)
    RLGL.vertex_3f(x + width/2, y - height/2, z - length/2) # Top Left Of The Texture and Quad
    RLGL.texcoord_2f(0.0, 0.0)
    RLGL.vertex_3f(x + width/2, y - height/2, z + length/2) # Bottom Left Of The Texture and Quad
    RLGL.texcoord_2f(1.0, 0.0)
    RLGL.vertex_3f(x - width/2, y - height/2, z + length/2) # Bottom Right Of The Texture and Quad
    # Right face
    RLGL.normal_3f(1.0, 0.0, 0.0) # Normal Pointing Right
    RLGL.texcoord_2f(1.0, 0.0)
    RLGL.vertex_3f(x + width/2, y - height/2, z - length/2) # Bottom Right Of The Texture and Quad
    RLGL.texcoord_2f(1.0, 1.0)
    RLGL.vertex_3f(x + width/2, y + height/2, z - length/2) # Top Right Of The Texture and Quad
    RLGL.texcoord_2f(0.0, 1.0)
    RLGL.vertex_3f(x + width/2, y + height/2, z + length/2) # Top Left Of The Texture and Quad
    RLGL.texcoord_2f(0.0, 0.0)
    RLGL.vertex_3f(x + width/2, y - height/2, z + length/2) # Bottom Left Of The Texture and Quad
    # Left Face
    RLGL.normal_3f(-1.0, 0.0, 0.0) # Normal Pointing Left
    RLGL.texcoord_2f(0.0, 0.0)
    RLGL.vertex_3f(x - width/2, y - height/2, z - length/2) # Bottom Left Of The Texture and Quad
    RLGL.texcoord_2f(1.0, 0.0)
    RLGL.vertex_3f(x - width/2, y - height/2, z + length/2) # Bottom Right Of The Texture and Quad
    RLGL.texcoord_2f(1.0, 1.0)
    RLGL.vertex_3f(x - width/2, y + height/2, z + length/2) # Top Right Of The Texture and Quad
    RLGL.texcoord_2f(0.0, 1.0)
    RLGL.vertex_3f(x - width/2, y + height/2, z - length/2) # Top Left Of The Texture and Quad
    RLGL.end
    # rlPopMatrix()

    RLGL.set_texture(0)
  end
end
