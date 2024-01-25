module Glades
  # The hud class
  class Hud
    # The hud render texture to render onto the screen
    getter hud_render_texture : Raylib::RenderTexture = Raylib::RenderTexture.new

    # The viewport which the 3d world is rendered to
    getter viewport_render_texture : Raylib::RenderTexture | Nil

    def initialize
      @hud_render_texture = Raylib.load_render_texture(
        Glades::HudConstants::SCREEN_RES_X,
        Glades::HudConstants::SCREEN_RES_Y
      )

      @width_scale = 0.0

      @hud_render_dest = Raylib::Rectangle.new

      @viewport_dest = Raylib::Rectangle.new
    end

    def load_viewport
      unload_viewport
      @viewport_render_texture = Raylib.load_render_texture(
        Glades::HudConstants::VIEWPORT_RES_X,
        Glades::HudConstants::VIEWPORT_RES_Y
      )
    end

    def unload_viewport
      Raylib.unload_render_texture(@viewport_render_texture.as(Raylib::RenderTexture)) unless @viewport_render_texture.nil?
      @viewport_render_texture = nil
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

      @viewport_dest = Raylib::Rectangle.new(
        x: (Glades::HudConstants::SCREEN_RES_X/2 - 1500/2)*@width_scale,
        y: Glades::HudConstants::SCREEN_RES_Y/2 - 1000/2,
        width: 1500*@width_scale,
        height: 1000,
      )
    end

    # Draws stuff onto the hud
    def draw
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
    end
  end
end
