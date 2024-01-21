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

color_block = MapFile::ColorCube.new

location = MapFile::Vector3.new
location.x = 2
location.y = 3
location.z = 4

color_block.location = location

size = MapFile::Vector3.new
size.x = 2
size.y = 1
size.z = 2

color_block.size = size

color = MapFile::Vector3.new
color.x = 40
color.y = 100
color.z = 221

color_block.color = color

map.objects << color_block

tex_block = MapFile::TexCube.new

location = MapFile::Vector3.new
location.x = 2
location.y = 0
location.z = 2

tex_block.location = location

size = MapFile::Vector3.new
size.x = 1
size.y = 1
size.z = 1

tex_block.size = size

tex_block.texture_path = "./rsrc/test.png"

map.objects << tex_block

File.open("./rsrc/testmap.dmap", "w+") do |file|
  map.write(file)
end
