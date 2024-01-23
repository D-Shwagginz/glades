class MapFile
  class Light < Object
    property color : Vector3 = Vector3.new

    def write(io : IO) : Int
      byte_size = 0

      io.write_bytes(Objects::Light.value.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io.write_bytes(location.x.to_i16, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(location.y.to_i16, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(location.z.to_i16, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io.write_bytes(color.x.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(color.y.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(color.z.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      byte_size
    end

    def self.read(file : IO) : Light
      object = Light.new

      location = Vector3.new
      location.x = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      location.y = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      location.z = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
      object.location = location

      color = Vector3.new
      color.x = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      color.y = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      color.z = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      object.color = color

      object
    end

    def self.from_parameters(chars : Array(Char)) : Light
      light = Light.new
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

      light.location.x = parameters[0].to_i16
      light.location.y = parameters[1].to_i16
      light.location.z = parameters[2].to_i16

      light.color.x = parameters[3].to_u8
      light.color.y = parameters[4].to_u8
      light.color.z = parameters[5].to_u8

      light
    end
  end
end
