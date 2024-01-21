module Glades
  class Map
    def self.load(map_file : MapFile)
      map_file.objects.each do |object|
        if object.is_a?(MapFile::ColorCube)
          ColorCube.from_file(object.as(MapFile::ColorCube))
        end
      end
    end
  end
end
