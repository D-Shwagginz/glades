class MapFile
  class DObj < Object
    property size : Vector3 = Vector3.new
    property file_path : String | Path = ""
    property num_of_objects : UInt16 = 0_u16
    property objects : Array(Object) = [] of Object

    def write(path : String | Path, write_to_map : Bool = false) : Int
      File.open(path, "w+") do |file|
        return write(file, write_to_map)
      end
    end

    def write(io : IO, write_to_map : Bool = false) : Int32
      byte_size = 0
      if write_to_map
        io.write_bytes(Objects::DObj.value.to_u8, IO::ByteFormat::LittleEndian)
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

        io.write_bytes(file_path.to_s.size.to_u8, IO::ByteFormat::LittleEndian)
        byte_size += 1

        io << file_path
        byte_size += file_path.to_s.size
      else
        num_of_objects = objects.size.to_u16

        objects.each do |object|
          if object.is_a?(DObj)
            num_of_objects += object.num_of_objects - 1
          end
        end

        io.write_bytes(num_of_objects.to_u16, IO::ByteFormat::LittleEndian) unless write_to_map
        byte_size += 2 unless write_to_map

        objects.each do |object|
          if object.is_a?(DObj)
            byte_size += object.write(io, true)
          else
            byte_size += object.write(io)
          end
        end
      end
      byte_size
    end

    def self.read(filename : Path | String, location : Vector3 = Vector3.new, size : Vector3 = Vector3.new) : DObj
      File.open(filename) do |file|
        return read(file, false, filename, location, size)
      end
    end

    def self.read(file : IO, read_from_map : Bool = false, file_path : String | Path = "", location : Vector3 = Vector3.new, size : Vector3 = Vector3.new) : DObj
      if read_from_map
        location = Vector3.new
        location.x = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        location.y = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)
        location.z = file.read_bytes(Int16, IO::ByteFormat::LittleEndian)

        size = Vector3.new
        size.x = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        size.y = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
        size.z = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)

        file_path_len = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)

        file_path = file.gets(file_path_len).to_s

        read(file_path, location: location, size: size)
      else
        obj = DObj.new

        obj.file_path = file_path

        obj.location = location
        obj.size = size

        obj.num_of_objects = file.read_bytes(UInt16, IO::ByteFormat::LittleEndian)

        obj.num_of_objects.times do
          current_object_type = file.read_bytes(UInt8, IO::ByteFormat::LittleEndian)
          case current_object_type
          when Objects::ColorCube.value
            obj.objects << ColorCube.read(file)
          when Objects::TexCube.value
            obj.objects << TexCube.read(file)
          end
        end

        obj
      end
    end

    def self.from_parameters(chars : Array(Char)) : DObj
      dobj = DObj.new
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

      dobj.location.x = parameters[0].to_i16
      dobj.location.y = parameters[1].to_i16
      dobj.location.z = parameters[2].to_i16

      dobj.size.x = parameters[3].to_u8
      dobj.size.y = parameters[4].to_u8
      dobj.size.z = parameters[5].to_u8

      dobj.file_path = parameters[6].to_s

      dobj
    end
  end
end
