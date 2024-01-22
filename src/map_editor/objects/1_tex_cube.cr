class MapFile
  class TexCube < Object
    property size : Vector3 = Vector3.new
    property texture_path : String = ""

    def write(io : IO) : Int
      byte_size = 0

      io.write_bytes(Objects::TexCube.value.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io.write_bytes(has_collision.to_unsafe.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io.write_bytes(location.x.to_i16, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(location.y.to_i16, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(location.z.to_i16, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io.write_bytes(size.x.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(size.y.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(size.z.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io.write_bytes(texture_path.size.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io << texture_path
      byte_size += texture_path.size

      byte_size
    end

    def self.read(file : IO) : TexCube
      object = TexCube.new

      object.has_collision = false if file.read_bytes(UInt8, IO::ByteFormat::LittleEndian) == 0

      location = Vector3.new
      location.x = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      location.y = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      location.z = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      object.location = location

      size = Vector3.new
      size.x = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      size.y = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      size.z = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      object.size = size

      texture_path_len = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)

      object.texture_path = file.gets(texture_path_len).to_s

      object
    end

    def self.from_parameters(chars : Array(Char)) : TexCube
      tex_cube = TexCube.new
      current_parameter = [] of Char
      parameters = [] of String

      chars.each.with_index do |char, index|
        if char == ','
          next
        elsif char == ' '
          parameters << current_parameter.join
          current_parameter = [] of Char
        else
          current_parameter << char

          if index == chars.size - 1
            parameters << current_parameter.join
          end
        end
      end

      tex_cube.has_collision = false if parameters[0].to_i == 0

      tex_cube.location.x = parameters[1].to_i16
      tex_cube.location.y = parameters[2].to_i16
      tex_cube.location.z = parameters[3].to_i16

      tex_cube.size.x = parameters[4].to_u8
      tex_cube.size.y = parameters[5].to_u8
      tex_cube.size.z = parameters[6].to_u8

      tex_cube.texture_path = parameters[7].to_s

      tex_cube
    end
  end
end
