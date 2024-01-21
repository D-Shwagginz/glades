module Glades
  class Map
    def self.load(map_file : MapFile)
      map_file.objects.each do |object|
        if object.is_a?(MapFile::ColorCube)
          ColorCube.from_file(object.as(MapFile::ColorCube))
        elsif object.is_a?(MapFile::TexCube)
          TexCube.from_file(object.as(MapFile::TexCube))
        end
      end
    end
  end
end
