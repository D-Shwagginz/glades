module Glades
  def self.setup_shader
    @@light_layers.times do
      ambient_light = Raylib::Color.new(
        r: @@start_map.as(MapFile).ambient_light.x,
        g: @@start_map.as(MapFile).ambient_light.y,
        b: @@start_map.as(MapFile).ambient_light.z
      )

      # Load basic lighting shader
      shader = Raylib.load_shader("./rsrc/shaders/lighting.vs", "./rsrc/shaders/lighting.fs")

      # Get some required shader locations
      shader.locs[Raylib::ShaderLocationIndex::VectorView.value] = Raylib.get_shader_location(shader, "viewPos")

      # Ambient light level (some basic lighting)
      ambient_loc = Raylib.get_shader_location(shader, "ambient")
      Raylib.set_shader_value(shader, ambient_loc, LibC::Float[ambient_light.r/255, ambient_light.g/255, ambient_light.b/255, 1.0], Raylib::ShaderUniformDataType::Vec4.value)

      # Sets the light falloff
      # Uses a vector, but ignores the second variable because pointers are wack
      light_falloff_loc = Raylib.get_shader_location(shader, "lightFalloff")
      Raylib.set_shader_value(shader, light_falloff_loc, LibC::Float[Glades::GameConstants::LIGHT_FALLOFF, 0.0], Raylib::ShaderUniformDataType::Vec2.value)

      @@shaders << shader
    end

    @@actors.each do |actor|
      if actor.responds_to?(:set_shader)
        actor.set_shader(@@shaders[actor.light_layer])
      end
    end

    @@lights.each do |light|
      light.load_light(@@shaders[light.light_layer])
    end
  end
end
