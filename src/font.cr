require "./glyph"

module Fontanyl
  class Font
    property charmap : Hash(Char, Glyph)

    def initialize
      @charmap = Hash(Char, Glyph).new
    end
  end
end
