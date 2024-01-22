class MapFile
  class ColorCube < Object
    property size : Vector3 = Vector3.new
    property color : Vector3 = Vector3.new

    def write(io : IO) : Int
      byte_size = 0

      io.write_bytes(Objects::ColorCube.value.to_u8, IO::ByteFormat::LittleEndian)
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

      io.write_bytes(color.x.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(color.y.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(color.z.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      byte_size
    end

    def self.read(file : IO) : ColorCube
      object = ColorCube.new

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

      color = Vector3.new
      color.x = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      color.y = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      color.z = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      object.color = color

      object
    end

    def self.from_parameters(chars : Array(Char)) : ColorCube
      color_cube = ColorCube.new
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

      color_cube.has_collision = false if parameters[0].to_i == 0

      color_cube.location.x = parameters[1].to_i16
      color_cube.location.y = parameters[2].to_i16
      color_cube.location.z = parameters[3].to_i16

      color_cube.size.x = parameters[4].to_u8
      color_cube.size.y = parameters[5].to_u8
      color_cube.size.z = parameters[6].to_u8

      color_cube.color.x = parameters[7].to_u8
      color_cube.color.y = parameters[8].to_u8
      color_cube.color.z = parameters[9].to_u8

      color_cube
    end
  end
end
