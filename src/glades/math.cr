module Glades
  struct Timer
    start_time : Float64
    life_time : Float64
  end

  def self.timer()

  def self.mapfile_vector3_to_raylib(v3 : MapFile::Vector3) : Raylib::Vector3
    return Raylib::Vector3.new(x: v3.x, y: v3.y, z: v3.z)
  end

  def self.get_forward_vector(rotation : Raylib::Vector3, radians : Bool = false) : Raylib::Vector3
    rotation *= Raylib::DEG2RAD unless radians

    return Raymath.vector3_normalize(
      Raylib::Vector3.new(
        x: Math.cos(rotation.x)*Math.sin(rotation.y),
        y: -Math.sin(rotation.x),
        z: Math.cos(rotation.x)*Math.cos(rotation.y)
      )
    )
  end

  def self.get_up_vector(rotation : Raylib::Vector3, radians : Bool = false) : Raylib::Vector3
    forward = Glades.get_forward_vector(rotation, radians)
    right = Glades.get_right_vector(rotation, radians)

    return Raymath.vector3_normalize(
      Raymath.vector3_cross_product(
        forward,
        right
      )
    )
  end

  def self.get_right_vector(rotation : Raylib::Vector3, radians : Bool = false) : Raylib::Vector3
    rotation *= Raylib::DEG2RAD unless radians

    return Raymath.vector3_normalize(
      Raylib::Vector3.new(
        x: -Math.cos(rotation.y),
        y: 0,
        z: Math.sin(rotation.y)
      )
    )
  end
end
