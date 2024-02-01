module Glades
  def self.check_collisions(actor : Actor)
    @@actors.each do |check_against|
      actor.collided(check_against) if (
                                         actor != check_against &&
                                         check_against.has_collision &&
                                         Raylib.check_collision_boxes?(actor.bounding_box, check_against.bounding_box)
                                       )
    end
  end

  def self.what_looking_at : Actor | Nil
    camera = @@player.as(Player).camera
    center = camera.position + Raylib.get_camera_forward(pointerof(camera)).scale(Glades::PlayerConstants::INTERACT_DISTANCE)

    @@actors.each do |check_against|
      return check_against if ( # check_against.has_collision &&

Raylib.check_collision_box_sphere?(check_against.bounding_box, center, 0.2)
                                )
    end
  end

  def self.check_collisions(bounding_box : Raylib::BoundingBox) : Actor | Nil
    @@actors.each do |check_against|
      return check_against if (
                                bounding_box != check_against.bounding_box &&
                                check_against.has_collision &&
                                Raylib.check_collision_boxes?(bounding_box, check_against.bounding_box)
                              )
    end
    return nil
  end
end
