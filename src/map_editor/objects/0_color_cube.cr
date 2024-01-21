class MapFile
  class ColorCube < Object
    property size : Vector3 = Vector3.new
    property color : Vector3 = Vector3.new

    def write(io : IO) : Int
      byte_size = 0

      io.write_bytes(Objects::ColorCube.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io.write_bytes(location.x.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(location.y.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(location.z.to_u8, IO::ByteFormat::LittleEndian)
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

      location = Vector3.new
      location.x = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      location.y = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      location.z = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
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
  end
end
