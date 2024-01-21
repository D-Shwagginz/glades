class MapFile
  class TexCube < Object
    property size : Vector3 = Vector3.new
    property texture_path : String = ""

    def write(io : IO) : Int
      byte_size = 0

      io.write_bytes(Objects::TexCube.value.to_u8, IO::ByteFormat::LittleEndian)
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

      io.write_bytes(texture_path.size.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io << texture_path
      byte_size += texture_path.size

      byte_size
    end

    def self.read(file : IO) : TexCube
      object = TexCube.new

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

      texture_path_len = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)

      object.texture_path = file.gets(texture_path_len).to_s

      object
    end
  end
end
