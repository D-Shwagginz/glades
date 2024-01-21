module Glades
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
