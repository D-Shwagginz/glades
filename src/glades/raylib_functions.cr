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

    def self.destroy_all
      Glades.lights.each do |light|
        light.light.enabled = false
        update(light.shader, light.light)

        Glades.delete_light(light)
        @@count -= 1
      end
    end
  end

  def self.draw_cube_texture(texture : Raylib::Texture2D, source : Raylib::Rectangle, position : Raylib::Vector3, size : Raylib::Vector3, color : Raylib::Color)
    x = position.x
    y = position.y
    z = position.z

    width = size.x
    height = size.y
    length = size.z

    tex_width = -texture.width
    tex_height = -texture.height

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
    # Front face
    RLGL.normal_3f(0.0, 0.0, 1.0)
    RLGL.texcoord_2f(source.x/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x - width/2, y - height/2, z + length/2)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x + width/2, y - height/2, z + length/2)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x + width/2, y + height/2, z + length/2)
    RLGL.texcoord_2f(source.x/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x - width/2, y + height/2, z + length/2)
    # Back face
    RLGL.normal_3f(0.0, 0.0, -1.0)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x - width/2, y - height/2, z - length/2)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x - width/2, y + height/2, z - length/2)
    RLGL.texcoord_2f(source.x/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x + width/2, y + height/2, z - length/2)
    RLGL.texcoord_2f(source.x/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x + width/2, y - height/2, z - length/2)
    # Top face
    RLGL.normal_3f(0.0, 1.0, 0.0)
    RLGL.texcoord_2f(source.x/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x - width/2, y + height/2, z - length/2)
    RLGL.texcoord_2f(source.x/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x - width/2, y + height/2, z + length/2)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x + width/2, y + height/2, z + length/2)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x + width/2, y + height/2, z - length/2)
    # Bottom face
    RLGL.normal_3f(0.0, -1.0, 0.0)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x - width/2, y - height/2, z - length/2)
    RLGL.texcoord_2f(source.x/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x + width/2, y - height/2, z - length/2)
    RLGL.texcoord_2f(source.x/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x + width/2, y - height/2, z + length/2)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x - width/2, y - height/2, z + length/2)
    # Right face
    RLGL.normal_3f(1.0, 0.0, 0.0)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x + width/2, y - height/2, z - length/2)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x + width/2, y + height/2, z - length/2)
    RLGL.texcoord_2f(source.x/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x + width/2, y + height/2, z + length/2)
    RLGL.texcoord_2f(source.x/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x + width/2, y - height/2, z + length/2)
    # Left face
    RLGL.normal_3f(-1.0, 0.0, 0.0)
    RLGL.texcoord_2f(source.x/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x - width/2, y - height/2, z - length/2)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, (source.y + source.height)/tex_height)
    RLGL.vertex_3f(x - width/2, y - height/2, z + length/2)
    RLGL.texcoord_2f((source.x + source.width)/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x - width/2, y + height/2, z + length/2)
    RLGL.texcoord_2f(source.x/tex_width, source.y/tex_height)
    RLGL.vertex_3f(x - width/2, y + height/2, z - length/2)
    RLGL.end
    # rlPopMatrix()

    RLGL.set_texture(0)
  end

  def self.gen_mesh_cube(texture : Raylib::Texture2D, source : Raylib::Rectangle, size : Raylib::Vector3) : Raylib::Mesh
    width = size.x
    height = size.y
    length = size.z

    tex_width = -texture.width
    tex_height = -texture.height

    mesh = Raylib.gen_mesh_cube(width, height, length)

    texcoords = [
      # Front Face
      source.x/tex_width, (source.y + source.height)/tex_height + 0.0314,
      (source.x + source.width)/tex_width + 0.0314, (source.y + source.height)/tex_height + 0.0314,
      (source.x + source.width)/tex_width + 0.0314, source.y/tex_height,
      source.x/tex_width, source.y/tex_height,
      # Back Face
      (source.x + source.width)/tex_width + 0.0314, (source.y + source.height)/tex_height + 0.0314,
      (source.x + source.width)/tex_width + 0.0314, source.y/tex_height,
      source.x/tex_width, source.y/tex_height,
      source.x/tex_width, (source.y + source.height)/tex_height + 0.0314,
      # Top Face
      source.x/tex_width, source.y/tex_height,
      source.x/tex_width, (source.y + source.height)/tex_height + 0.0314,
      (source.x + source.width)/tex_width + 0.0314, (source.y + source.height)/tex_height + 0.0314,
      (source.x + source.width)/tex_width + 0.0314, source.y/tex_height,
      # Bottom Face
      (source.x + source.width)/tex_width + 0.0314, source.y/tex_height,
      source.x/tex_width, source.y/tex_height,
      source.x/tex_width, (source.y + source.height)/tex_height + 0.0314,
      (source.x + source.width)/tex_width + 0.0314, (source.y + source.height)/tex_height + 0.0314,
      # Right Face
      (source.x + source.width)/tex_width + 0.0314, (source.y + source.height)/tex_height + 0.0314,
      (source.x + source.width)/tex_width + 0.0314, source.y/tex_height,
      source.x/tex_width, source.y/tex_height,
      source.x/tex_width, (source.y + source.height)/tex_height + 0.0314,
      # Left Face
      source.x/tex_width, (source.y + source.height)/tex_height + 0.0314,
      (source.x + source.width)/tex_width + 0.0314, (source.y + source.height)/tex_height + 0.0314,
      (source.x + source.width)/tex_width + 0.0314, source.y/tex_height,
      source.x/tex_width, source.y/tex_height,
    ]

    Raylib.update_mesh_buffer(mesh, 1, texcoords, sizeof(LibC::Float) * texcoords.size, 0)
    return mesh
  end
end
