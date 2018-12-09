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
      @charmap[c]
    end
  end
end
