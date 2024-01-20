module Glades
  class Actor
    property location : Raylib::Vector3
    property rotation : Raylib::Vector3

    def initialize(
      location : Raylib::Vector3 = Raylib::Vector3.new,
      rotation : Raylib::Vector3 = Raylib::Vector3.new
    )
      @location = location
      @rotation = rotation
      Glades.add_actor(self)
    end

    def destroy
      Glades.delete_actor(self)
    end
  end
end
