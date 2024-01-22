module Glades
  class Map
    def self.load_object(
      object : MapFile::Object,
      location_offset : Raylib::Vector3 | MapFile::Vector3 = Raylib::Vector3.new,
      size_offset : Raylib::Vector3 | MapFile::Vector3 = Raylib::Vector3.new(x: 1, y: 1, z: 1)
    )
      if object.is_a?(MapFile::ColorCube)
        ColorCube.from_file(object.as(MapFile::ColorCube), location_offset, size_offset)
      elsif object.is_a?(MapFile::TexCube)
        TexCube.from_file(object.as(MapFile::TexCube), location_offset, size_offset)
      elsif object.is_a?(MapFile::DObj)
        object.as(MapFile::DObj).objects.each do |obj_object|
          load_object(obj_object, object.as(MapFile::DObj).location, object.as(MapFile::DObj).size)
        end
      end
    end

    def self.load(map_file : MapFile)
      map_file.objects.each do |object|
        load_object(object)
      end
    end
  end
end
