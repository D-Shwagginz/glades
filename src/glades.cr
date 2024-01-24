require "./glades/**"
require "./map_editor"
require "raylib-cr"
require "raylib-cr/rlgl"
require "option_parser"

# The main Glades module
module Glades
  VERSION = "0.0.1"

  @@start_map

  def self.run_cli
    start_map_location : String = ""

    OptionParser.parse do |parser|
      parser.banner = "Usage: salute [arguments]"
      parser.on("-m PATH", "--map=PATH", "Specifies the map to load") { |path| start_map_location = path }
      parser.on("-h", "--help", "Show this help") do
        puts parser
        exit
      end
    end

    run(MapFile.read(start_map_location))
  end
end

Glades.run_cli
