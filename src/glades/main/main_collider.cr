module Glades
  def self.check_collisions(actor : Actor)
    @@actors.each do |check_against|
      actor.collided(check_against) if (
                                         actor != check_against &&
                                         Raylib.check_collision_boxes?(actor.bounding_box, check_against.bounding_box)
                                       )
    end
  end

  def self.check_collisions(bounding_box : Raylib::BoundingBox) : Actor | Nil
    @@actors.each do |check_against|
      return check_against if (
                                bounding_box != check_against.bounding_box &&
                                Raylib.check_collision_boxes?(bounding_box, check_against.bounding_box)
                              )
    end
    return nil
  end
end
