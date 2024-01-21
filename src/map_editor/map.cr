class MapFile
  struct Vector3
    property x : UInt8 = 0_u8
    property y : UInt8 = 0_u8
    property z : UInt8 = 0_u8
  end

  enum Objects
    ColorCube
    TexCube
  end

  property num_of_objects : UInt16 = 0_u16
  property objects : Array(Object) = [] of Object

  def write(file : String | Path) : Int
    File.open(file, "w+") do |file|
      return write(file)
    end
  end

  def write(io : IO) : Int
    byte_size = 0

    num_of_objects = objects.size.to_u16

    io.write_bytes(num_of_objects.to_u16, IO::ByteFormat::LittleEndian)
    byte_size += 2

    objects.each do |object|
      byte_size += object.write(io)
    end

    byte_size
  end

  def self.read(filename : Path | String) : MapFile
    File.open(filename) do |file|
      return read(file)
    end
  end

  def self.read(file : IO) : MapFile
    map = MapFile.new

    map.num_of_objects = file.read_bytes(UInt16, IO::ByteFormat::LittleEndian)

    map.num_of_objects.times do
      current_object_type = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      case current_object_type
      when Objects::ColorCube.value
        map.objects << ColorCube.read(file)
      when Objects::TexCube.value
        map.objects << TexCube.read(file)
      end
    end

    map
  end
end
