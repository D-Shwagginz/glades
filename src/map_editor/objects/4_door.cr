class MapFile
  class Door < Object
    property size : Vector3 = Vector3.new
    property file_path : String = ""

    def write(io : IO) : Int
      byte_size = 0

      io.write_bytes(Objects::Door.value.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io.write_bytes(light_layer.to_u16, IO::ByteFormat::LittleEndian)
      byte_size += 2

      io.write_bytes(location.x.to_i16, IO::ByteFormat::LittleEndian)
      byte_size += 2
      io.write_bytes(location.y.to_i16, IO::ByteFormat::LittleEndian)
      byte_size += 2
      io.write_bytes(location.z.to_i16, IO::ByteFormat::LittleEndian)
      byte_size += 2

      io.write_bytes(size.x.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(size.y.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(size.z.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io.write_bytes(file_path.size.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io << file_path
      byte_size += file_path.size

      byte_size
    end

    def self.read(file : IO) : Door
      object = Door.new

      object.light_layer = file.read_bytes(UInt16, IO::ByteFormat::LittleEndian)

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

      file_path_len = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)

      object.file_path = file.gets(file_path_len).to_s

      object
    end

    def self.from_parameters(chars : Array(Char)) : Door
      door = Door.new
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

      door.light_layer = parameters[0].to_u16

      door.location.x = parameters[1].to_i16
      door.location.y = parameters[2].to_i16
      door.location.z = parameters[3].to_i16

      door.size.x = parameters[4].to_u8
      door.size.y = parameters[5].to_u8
      door.size.z = parameters[6].to_u8

      door.file_path = parameters[7].to_s

      door
    end
  end
end
