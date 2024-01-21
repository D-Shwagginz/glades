module Glades
  # def self.normalize_highest_vector(vector : Raylib::Vector3) : Raylib::Vector3
  #   highest = Raymath.vector3_normalize(vector)

  #   if vector.x.abs > vector.y.abs && vector.x.abs > vector.z.abs
  #     highest.y = 0
  #     highest.z = 0
  #   elsif vector.y.abs > vector.x.abs && vector.y.abs > vector.z.abs
  #     highest.x = 0
  #     highest.z = 0
  #   else
  #     highest.x = 0
  #     highest.y = 0
  #   end

  #   return highest
  # end

  # def self.normalize_lowest_vector(vector : Raylib::Vector3, zero_doesnt_count : Bool = false) : Raylib::Vector3
  #   lowest = Raymath.vector3_normalize(vector)

  #   if zero_doesnt_count
  #     if vector.x.abs != 0 && vector.x.abs < vector.y.abs && vector.x.abs < vector.z.abs
  #       lowest.y = 0
  #       lowest.z = 0
  #     elsif vector.y.abs != 0 && vector.y.abs < vector.x.abs && vector.y.abs < vector.z.abs
  #       lowest.x = 0
  #       lowest.z = 0
  #     else
  #       lowest.x = 0
  #       lowest.y = 0
  #     end
  #   else
  #     if vector.x.abs < vector.y.abs && vector.x.abs < vector.z.abs
  #       lowest.y = 0
  #       lowest.z = 0
  #     elsif vector.y.abs < vector.x.abs && vector.y.abs < vector.z.abs
  #       lowest.x = 0
  #       lowest.z = 0
  #     else
  #       lowest.x = 0
  #       lowest.y = 0
  #     end
  #   end

  #   return lowest
  # end

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
