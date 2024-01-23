require "./map_editor/**"

def parse_text(path : String | Path) : Tuple(String, MapFile, MapFile::DObj, Bool)
  map = MapFile.new
  dobj = MapFile::DObj.new
  is_dobj = false
  map_name = ""
  ambient_light = MapFile::Vector3.new

  File.open(path) do |file|
    file_string = file.gets_to_end

    file_string.each_line.with_index do |line, line_index|
      chars = line.chars
      command = ""
      parameters = [] of Char

      ambient_light_parse = [] of String
      light_value = [] of Char

      if chars.size > 0 && chars[0] != '#'
        if line_index == 0
          is_dobj = true if line == "dobj"
        elsif line_index == 1
          map_name = line
        elsif line_index == 2 && !is_dobj
          chars.each.with_index do |char, index|
            if char == ' '
              ambient_light_parse << light_value.join
              light_value = [] of Char
            else
              light_value << char

              if index == chars.size - 1
                ambient_light_parse << light_value.join
              end
            end
          end

          ambient_light.x = ambient_light_parse[0].to_u8
          ambient_light.y = ambient_light_parse[1].to_u8
          ambient_light.z = ambient_light_parse[2].to_u8
        else
          chars.each.with_index do |char, index|
            if char == '('
              command = chars[0...index].join
              chars.delete_at(0..index)
              chars.delete_at(-1)
              parameters = chars
              break
            end
          end
        end

        case command
        when "colorcube"
          map.objects << MapFile::ColorCube.from_parameters(parameters)
          dobj.objects << MapFile::ColorCube.from_parameters(parameters)
        when "texcube"
          map.objects << MapFile::TexCube.from_parameters(parameters)
          dobj.objects << MapFile::TexCube.from_parameters(parameters)
        when "dobj"
          map.objects << MapFile::DObj.from_parameters(parameters)
          dobj.objects << MapFile::DObj.from_parameters(parameters)
        when "light"
          map.objects << MapFile::Light.from_parameters(parameters)
          dobj.objects << MapFile::Light.from_parameters(parameters)
        end
      end
    end

    map.ambient_light = ambient_light

    return {map_name, map, dobj, is_dobj}
  end
end

def export_text(path : String | Path, export_path : String | Path)
  map = parse_text(path)
  extension = ".dmap"
  extension = ".dobj" if map[3]

  File.open(export_path + map[0] + extension, "w+") do |file|
    if map[3]
      map[2].write(file)
    else
      map[1].write(file)
    end
  end
end

export_text("./rsrc/obj.txt", "./rsrc/")
export_text("./rsrc/map.txt", "./rsrc/")
