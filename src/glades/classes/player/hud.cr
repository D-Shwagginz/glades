module Glades
  # The hud class
  class Hud
    # The hud render texture to render onto the screen
    getter hud_render_texture : Raylib::RenderTexture = Raylib::RenderTexture.new

    # The viewport which the 3d world is rendered to
    getter viewport_render_texture : Raylib::RenderTexture | Nil

    getter width_scale : Float64 = 0.0

    enum TexturePaths
      HudBackground = 0
      Crosshair     = 2
      BaseballBat   = 1
    end

    # [0]: Hud Background
    # [1]: Baseball Bat
    # [2]: Crosshair
    @texture_paths = [
      "./rsrc/hud/HudBackground.png",
      "./rsrc/hud/Bat.png",
      "./rsrc/hud/Crosshair.png",
    ]

    @loaded_textures : Array(Tuple(String, Raylib::Texture)) = [] of Tuple(String, Raylib::Texture)

    def initialize
      @hud_render_texture = Raylib.load_render_texture(
        Glades::HudConstants::SCREEN_RES_X,
        Glades::HudConstants::SCREEN_RES_Y
      )

      @hud_render_dest = Raylib::Rectangle.new

      @hud_background_dest = Raylib::Rectangle.new

      @viewport_dest = Raylib::Rectangle.new

      @crosshair_dest = Raylib::Rectangle.new

      @weapon_dest = Raylib::Rectangle.new
    end

    def get_texture(path : String) : Raylib::Texture
      texture_tuple = @loaded_textures.find { |i| i[0] == path }
      unless texture_tuple.nil?
        return texture_tuple[1]
      else
        return Raylib::Texture.new
      end
    end

    def load
      @viewport_render_texture = Raylib.load_render_texture(
        Glades::HudConstants::VIEWPORT_RES_X,
        Glades::HudConstants::VIEWPORT_RES_Y
      )

      @texture_paths.each do |path|
        @loaded_textures << {path, Raylib.load_texture(path)}
      end
    end

    def unload
      Raylib.unload_render_texture(@viewport_render_texture.as(Raylib::RenderTexture)) unless @viewport_render_texture.nil?
      @viewport_render_texture = nil

      Raylib.unload_render_texture(@hud_render_texture.as(Raylib::RenderTexture)) unless @hud_render_texture.nil?

      @loaded_textures.each do |texture|
        Raylib.unload_texture(texture[1]) unless texture.nil?
      end
    end

    # Draws the hud onto the screen
    def draw_screen
      Raylib.draw_texture_pro(
        @hud_render_texture.as(Raylib::RenderTexture).texture,
        Raylib::Rectangle.new(
          x: 0,
          y: 0,
          width: @hud_render_texture.as(Raylib::RenderTexture).texture.width * @width_scale,
          height: -@hud_render_texture.as(Raylib::RenderTexture).texture.height,
        ),
        @hud_render_dest,
        Raylib::Vector2.new,
        0.0,
        Raylib::WHITE
      )
    end

    # The update code triggered before either draw
    def update
      @width_scale = (Raylib.get_screen_width/Glades::HudConstants::SCREEN_RES_X).clamp(nil, 1.0)

      @hud_render_dest = Raylib::Rectangle.new(
        x: (Raylib.get_screen_width - Glades::HudConstants::SCREEN_RES_X*Glades.screen_scale)*0.5,
        y: (Raylib.get_screen_height - Glades::HudConstants::SCREEN_RES_Y*Glades.screen_scale)*0.5,
        width: Glades::HudConstants::SCREEN_RES_X*Glades.screen_scale,
        height: Glades::HudConstants::SCREEN_RES_Y*Glades.screen_scale
      )

      @hud_background_dest = Raylib::Rectangle.new(
        x: @width_scale,
        y: 0,
        width: 2000*@width_scale,
        height: 1500,
      )

      @viewport_dest = Raylib::Rectangle.new(
        x: @width_scale,
        y: 0,
        width: 210*8*@width_scale,
        height: 140*8,
      )

      @crosshair_dest = Raylib::Rectangle.new(
        x: (@viewport_dest.width/2 - @crosshair_dest.width/2),
        y: @viewport_dest.height/2 - @crosshair_dest.height/2,
        width: get_texture(@texture_paths[TexturePaths::Crosshair.value]).width*4*@width_scale,
        height: get_texture(@texture_paths[TexturePaths::Crosshair.value]).height*4,
      )

      @weapon_dest = Raylib::Rectangle.new(
        x: 1734*@width_scale,
        y: 200,
        width: get_texture(@texture_paths[TexturePaths::BaseballBat.value]).width*8*@width_scale,
        height: get_texture(@texture_paths[TexturePaths::BaseballBat.value]).height*8,
      )
    end

    # Draws stuff onto the hud
    def draw
      Raylib.draw_texture_pro(
        get_texture(@texture_paths[TexturePaths::HudBackground.value]),
        Raylib::Rectangle.new(
          x: 0,
          y: 0,
          width: get_texture(@texture_paths[TexturePaths::HudBackground.value]).width,
          height: get_texture(@texture_paths[TexturePaths::HudBackground.value]).height,
        ),
        @hud_background_dest,
        Raylib::Vector2.new,
        0.0,
        Raylib::WHITE
      )

      if @viewport_render_texture
        Raylib.draw_texture_pro(
          @viewport_render_texture.as(Raylib::RenderTexture).texture,
          Raylib::Rectangle.new(
            x: 0,
            y: 0,
            width: @viewport_render_texture.as(Raylib::RenderTexture).texture.width,
            height: -@viewport_render_texture.as(Raylib::RenderTexture).texture.height,
          ),
          @viewport_dest,
          Raylib::Vector2.new,
          0.0,
          Raylib::WHITE
        )
      end

      Raylib.draw_texture_pro(
        get_texture(@texture_paths[TexturePaths::Crosshair.value]),
        Raylib::Rectangle.new(
          x: 0,
          y: 0,
          width: get_texture(@texture_paths[TexturePaths::Crosshair.value]).width,
          height: get_texture(@texture_paths[TexturePaths::Crosshair.value]).height,
        ),
        @crosshair_dest,
        Raylib::Vector2.new,
        0.0,
        Raylib::WHITE
      )

      Raylib.draw_text_ex(
        Glades.font,
        "Day : 99",
        Raylib::Vector2.new(x: 1722*@width_scale, y: 30),
        40*@width_scale,
        0,
        Raylib::BLACK
      )

      Raylib.draw_text_ex(
        Glades.font,
        "Time : 1:48 PM",
        Raylib::Vector2.new(x: 1722*@width_scale, y: 80),
        40*@width_scale,
        0,
        Raylib::BLACK
      )

      Raylib.draw_texture_pro(
        get_texture(@texture_paths[TexturePaths::BaseballBat.value]),
        Raylib::Rectangle.new(
          x: 0,
          y: 0,
          width: get_texture(@texture_paths[TexturePaths::BaseballBat.value]).width,
          height: get_texture(@texture_paths[TexturePaths::BaseballBat.value]).height,
        ),
        @weapon_dest,
        Raylib::Vector2.new,
        0.0,
        Raylib::WHITE
      )

      if Glades.player
        Bars.draw
      end

      Raylib.draw_text_ex(
        Glades.font,
        "#{Raylib.get_fps}",
        Raylib::Vector2.new(x: @width_scale, y: 0),
        40*@width_scale,
        0,
        Raylib::GREEN
      )
    end
  end
end
