require "bit_array"

module Fontanyl
  class Glyph
    property device_width_x : Int32
    property device_width_y : Int32
    property width : Int32
    property height : Int32
    property offset_x : Int32
    property offset_y : Int32
    property bitmap : BitArray

    def initialize
      @device_width_x = 0
      @device_width_y = 0
      @width = 0
      @height = 0
      @offset_x = 0
      @offset_y = 0
      @bitmap = BitArray.new(@width*@height)
    end

    def set_device_width(@device_width_x = @device_width_x, @device_width_y = @device_width_y)
    end

    def set_size(@width = @width, @height = @height)
      @bitmap = BitArray.new(@width*@height)
    end

    def set_offset(@offset_x = @offset_x, @offset_y = @offset_y)
    end

    def set_pixel(x, y, val : Bool)
      bitmap[width*y + x] = val
    end
  end
end
