module Glades
  class Map
    def self.load_object(object : MapFile::Object)
      if object.is_a?(MapFile::ColorCube)
        ColorCube.from_file(object.as(MapFile::ColorCube))
      elsif object.is_a?(MapFile::TexCube)
        TexCube.from_file(object.as(MapFile::TexCube))
      elsif object.is_a?(MapFile::DObj)
        object.as(MapFile::DObj).objects.each do |obj_object|
          load_object(obj_object)
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
