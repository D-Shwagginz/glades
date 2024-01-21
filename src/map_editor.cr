require "./map_editor/**"

map = MapFile.new

color_block = MapFile::ColorCube.new

location = MapFile::Vector3.new
location.x = 5
location.y = 0
location.z = 0

color_block.location = location

size = MapFile::Vector3.new
size.x = 1
size.y = 2
size.z = 1

color_block.size = size

color = MapFile::Vector3.new
color.x = 0
color.y = 94
color.z = 255

color_block.color = color

map.objects << color_block

File.open("./rsrc/testmap.dmap", "w+") do |file|
  map.write(file)
end
