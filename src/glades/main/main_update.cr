module Glades
  # Updates the game
  def self.update
    if @@player
      # Update the shader with the camera view vector (points towards { 0.0f, 0.0f, 0.0f })
      camera_pos = LibC::Float[@@player.as(Player).camera.position.x, @@player.as(Player).camera.position.y, @@player.as(Player).camera.position.z]

      @@shaders.each do |shader|
        Raylib.set_shader_value(
          shader, shader.locs[Raylib::ShaderLocationIndex::VectorView.value],
          camera_pos, Raylib::ShaderUniformDataType::Vec3
        )
      end
    end

    # Update light values
    @@lights.each do |light|
      Lights.update(@@shaders[light.light_layer], light.light)
    end

    # Updates each actor
    @@actors.each do |actor|
      if actor.responds_to?(:update)
        actor.update
      end
    end
  end
end
