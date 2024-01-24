class MapFile
  class Object
    property location : Vector3 = Vector3.new
    property has_collision : Bool = true
    property light_layer : UInt16 = 0

    def write(file : String | Path) : Int
      File.open(file, "w+") do |file|
        return write(file)
      end
    end

    def write(io : IO) : Int
      byte_size = 0_u32

      io.write_bytes(light_layer.to_u16, IO::ByteFormat::LittleEndian)
      byte_size += 2

      io.write_bytes(has_collision.to_unsafe.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      io.write_bytes(location.x.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(location.y.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1
      io.write_bytes(location.z.to_u8, IO::ByteFormat::LittleEndian)
      byte_size += 1

      byte_size
    end

    def self.read(filename : Path | String) : Object
      File.open(filename) do |file|
        return read(file)
      end
    end

    def self.read(file : IO) : Object
      object = Object.new

      object.light_layer = file.read_bytes(UInt16, IO::ByteFormat::LittleEndian)

      object.has_collision = false if file.read_bytes(UInt8, IO::ByteFormat::LittleEndian) == 0

      location = Vector3.new

      location.x = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      location.y = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      location.z = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)

      object.location = location

      object
    end
  end
end
