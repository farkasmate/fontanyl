require "./glyph"

module Fontanyl
  class Font
    property charmap : Hash(Char, Glyph)
    property family : String
    property size : UInt32

    def initialize
      @charmap = Hash(Char, Glyph).new
      @family = ""
      @size = 0_u32
    end

    def get(c : Char) : Glyph
      @charmap.fetch(c) { |c| raise Exception.new("No glyph for '#{c}'") }
    end

    def get_bitmap(msg : String, wrap : UInt32 = 0)
      chars = msg.chars
      char_count = chars.size
      glyphs = chars.map do |c|
        if c == ' '
          Glyph.new.set_device_width(get('a').device_width_x)
        else
          get(c)
        end
      end
      max_height = glyphs.uniq.max_by(&.height).height
      bitmap = Array(Array(Bool)).new
      pad = 0

      glyphs.each do |glyph|
        isize = glyph.height
        while isize < max_height
          bitmap << [false]*glyph.device_width_x
          isize += 1
        end
        if glyph.width > 0
          glyph.bitmap.each_slice(glyph.width).each do |line|
            bitmap << line + [false]*(glyph.device_width_x - glyph.width)
          end
        else
          glyph.height.times do |t|
            bitmap << [] of Bool
          end
        end
      end

      wrap = wrap == 0 ? char_count : wrap
      retmap = Array(Array(Array(Bool))).new((char_count/wrap).round) { Array(Array(Bool)).new(max_height) { Array(Bool).new } }
      bitmap.each_slice(max_height).with_index { |e, chari| e.map_with_index { |l, li| l.map { |i| retmap[chari/wrap][li] << i } } }
      retmap # .map { |e| e.reject { |s| s.size == 0 } }.reject { |a| a.size == 0 }
    end
  end
end
