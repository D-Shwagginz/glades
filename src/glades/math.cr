module Glades
  def self.get_actor_forward_vector(actor : Actor) : Raylib::Vector3
    location = actor.location
    rotation = actor.rotation

    return Raymath.vector3_normalize(
      Raylib::Vector3.new(
        x: Math.cos(rotation.x)*Math.cos(rotation.z),
        y: Math.sin(rotation.x),
        z: Math.cos(rotation.x)*Math.sin(rotation.z)
      ) + location
    )
  end

  def self.get_actor_up_vector(actor : Actor) : Raylib::Vector3
    location = actor.location

    return Raymath.vector3_normalize(
      Raylib::Vector3.new(
        x: location.x,
        y: location.y + 1.0,
        z: location.z
      )
    )
  end

  def self.get_actor_right_vector(actor : Actor) : Raylib::Vector3
    forward = Glades.get_actor_forward_vector(actor)
    up = Glades.get_actor_up_vector(actor)

    return Raymath.vector3_normalize(
      Raymath.vector3_cross_product(
        forward,
        up
      )
    )
  end
end
