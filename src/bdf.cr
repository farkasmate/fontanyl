require "./font"
require "./glyph"

require "big/big_int"

module Fontanyl
  class BDF < Font
    property data : Array(Array(String))
    property final : Bool

    def initialize(fontpath)
      super()
      @data = File.read_lines(fontpath).map(&.split)
      @final = false

      raise Exception.new("Not a BDF file: #{fontpath}") if @data.first.first != "STARTFONT"

      glyph = Glyph.new
      char = '\0'
      in_bitmap = false
      bitmap = Array(String).new
      bitmap_index = 1
      default_size = {0, 0}
      default_offset = {0, 0}
      startproperties_left = 0
      glyphs_expected = 0_u32

      @data.each.with_index do |bdfl, bdfi|
        if startproperties_left > 0
          case bdfl[0]
          when "FAMILY_NAME"
            # puts "Font family #{bdfl[1..-1].join(" ")}"
            @family = bdfl[1..-1].join(" ")
          end
          startproperties_left -= 1
          next
        end
        unless in_bitmap
          case bdfl[0]
          when "STARTFONT"
            # puts "BDF v#{bdfl[1]}"
            @final = false
          when "COMMENT"
            if bdfl.size > 1
              # puts "Comment: #{bdfl[1..-1].join(" ")}"
            end
          when "FONT"
            # x logical font description
          when "FONTBOUNDINGBOX"
            # puts "Default bounding box: #{bdfl[1..-1].map(&.to_i)}"
            default_size = {bdfl[1].to_i, bdfl[2].to_i}
            glyph.set_size(*default_size)
            default_offset = {bdfl[3].to_i, bdfl[4].to_i}
            glyph.set_offset(*default_offset)
          when "STARTPROPERTIES"
            startproperties_left = bdfl[1].to_i
          when "ENDPROPERTIES"
            startproperties_left = 0
          when "SIZE"
            # puts "Font size #{bdfl[1]}px"
            @size = bdfl[1].to_u32
          when "CHARS"
            # puts "#{bdfl[1]} glyphs will follow"
            glyphs_expected = bdfl[1].to_u32
          when "STARTCHAR"
            char = bdfl[1].to_i(16).chr
            # puts "got #{bdfl[1]} -> #{char}"
          when "ENCODING"
            # decimal code point of glyph in the font
          when "SWIDTH"
            # we don't do scalable glyphs in this household
          when "DWIDTH"
            glyph.set_device_width(bdfl[1].to_i, bdfl[2].to_i)
          when "BBX"
            glyph.set_size(bdfl[1].to_i, bdfl[2].to_i)
            glyph.set_offset(bdfl[3].to_i, bdfl[4].to_i)
          when "BITMAP"
            in_bitmap = true
          when "ENDCHAR"
            # puts "have #{char}"
            bitmap.each.with_index do |line, index|
              bits = line.size * 4 - 1
              glyph.width.times do |gwt|
                glyph.set_pixel(gwt, index, BigInt.new(line, 16).bit(bits - gwt) == 1)
              end
            end
            @charmap[char] = glyph
            bitmap = Array(String).new
            glyph = Glyph.new
            glyph.set_size(*default_size)
            glyph.set_offset(*default_offset)
          when "ENDFONT"
            @final = true
          else
            raise Exception.new("Unsupported BDF entity: #{bdfl}")
          end
        else
          if bitmap_index >= glyph.height
            in_bitmap = false
            bitmap_index = 1
          else
            bitmap_index += 1
            bitmap << bdfl[0]
          end
        end
      end
      # puts "Collected #{@charmap.size}/#{glyphs_expected} glyphs"
    end
  end
end
