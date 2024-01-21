module Glades
  class Map < Actor
    getter model : Raylib::Model

    def initialize(
      @location : Raylib::Vector3 = Raylib::Vector3.new,
      @rotation : Raylib::Vector3 = Raylib::Vector3.new,
      @model : Raylib::Model = Raylib::Model.new,
      @scale : Float32 = 1
    )
      @bounding_box_scale = Raylib::Vector3.new
      @bounding_box = Raylib.get_model_bounding_box(@model)

      Glades.add_actor(self)
    end

    def draw
      Raylib.draw_bounding_box(@bounding_box, Raylib::RED)
      # Raylib.draw_model(@model, @location, @scale, Raylib::WHITE)
    end

    def destroy
      Raylib.unload_model(@model)
      Glades.delete_actor(self)
    end
  end
end
