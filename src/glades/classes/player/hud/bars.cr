module Glades
  class Hud
    module Bars
      def self.draw
        (Glades.player.as(Player).health * (30/Glades.player.as(Player).max_health)).ceil.to_i.clamp(0, 30).times do |time|
          Raylib.draw_rectangle(
            Glades.hud.as(Hud).width_scale + 136 + 24*time,
            1195,
            16,
            32,
            Raylib::Color.new(g: 255, a: 255)
          )
        end

        (Glades.player.as(Player).stamina * (30/Glades.player.as(Player).max_stamina)).ceil.to_i.clamp(0, 30).times do |time|
          Raylib.draw_rectangle(
            Glades.hud.as(Hud).width_scale + 136 + 24*time,
            1291,
            16,
            32,
            Raylib::Color.new(r: 255, g: 255, a: 255)
          )
        end

        (Glades.player.as(Player).mana * (30/Glades.player.as(Player).max_mana)).ceil.to_i.clamp(0, 30).times do |time|
          Raylib.draw_rectangle(
            Glades.hud.as(Hud).width_scale + 136 + 24*time,
            1387,
            16,
            32,
            Raylib::Color.new(b: 255, a: 255)
          )
        end
      end
    end
  end
end
