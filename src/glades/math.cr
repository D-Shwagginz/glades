module Glades
  def self.get_actor_forward_vector(actor : Actor) : Raylib::Vector3
    location = actor.location
    rotation = actor.rotation*Raylib::DEG2RAD

    return Raymath.vector3_normalize(
      Raylib::Vector3.new(
        x: Math.cos(rotation.x)*Math.sin(rotation.y),
        y: -Math.sin(rotation.x),
        z: Math.cos(rotation.x)*Math.cos(rotation.y)
      )
    )
  end

  def self.get_actor_up_vector(actor : Actor) : Raylib::Vector3
    forward = Glades.get_actor_forward_vector(actor)
    right = Glades.get_actor_right_vector(actor)

    return Raymath.vector3_normalize(
      Raymath.vector3_cross_product(
        forward,
        right
      )
    )
  end

  def self.get_actor_right_vector(actor : Actor) : Raylib::Vector3
    location = actor.location
    rotation = actor.rotation*Raylib::DEG2RAD

    return Raymath.vector3_normalize(
      Raylib::Vector3.new(
        x: -Math.cos(rotation.y),
        y: 0,
        z: Math.sin(rotation.y)
      )
    )
  end
end
