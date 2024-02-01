class MapFile
  struct Vector3
    property x = 0
    property y = 0
    property z = 0
  end

  enum Objects
    ColorCube
    TexCube
    DObj
    Light
    Door
  end

  property num_of_objects : UInt16 = 0_u16
  property objects : Array(Object) = [] of Object
  property ambient_light : Vector3 = Vector3.new

  def write(file : String | Path) : Int
    File.open(file, "w+") do |file|
      return write(file)
    end
  end

  def write(io : IO) : Int
    byte_size = 0

    io.write_bytes(ambient_light.x.to_u8, IO::ByteFormat::LittleEndian)
    byte_size += 1
    io.write_bytes(ambient_light.y.to_u8, IO::ByteFormat::LittleEndian)
    byte_size += 1
    io.write_bytes(ambient_light.z.to_u8, IO::ByteFormat::LittleEndian)
    byte_size += 1

    num_of_objects = objects.size.to_u16

    io.write_bytes(num_of_objects.to_u16, IO::ByteFormat::LittleEndian)
    byte_size += 2

    objects.each do |object|
      if object.is_a?(DObj)
        byte_size += object.write(io, true)
      else
        byte_size += object.write(io)
      end
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

    ambient_light = Vector3.new
    ambient_light.x = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
    ambient_light.y = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
    ambient_light.z = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
    map.ambient_light = ambient_light

    map.num_of_objects = file.read_bytes(UInt16, IO::ByteFormat::LittleEndian)

    map.num_of_objects.times do
      current_object_type = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
      case current_object_type
      when Objects::ColorCube.value
        map.objects << ColorCube.read(file)
      when Objects::TexCube.value
        map.objects << TexCube.read(file)
      when Objects::DObj.value
        map.objects << DObj.read(file, true)
      when Objects::Light.value
        map.objects << Light.read(file)
      when Objects::Door.value
        map.objects << Door.read(file)
      end
    end

    map
  end
end
