require "./font"

module Fontanyl
  class BDF < Font
    property data : Array(Array(String))
    property final : Bool

    def initialize(fontpath)
      super()
      @data = File.read_lines(fontpath).map(&.split)
      @final = false

      raise Exception.new("Not a BDF file: #{fontpath}") if @data.first.first != "STARTFONT"

      @data.each do |bdfl|
        case bdfl[0]
        when "STARTFONT"
          puts "BDF v#{bdfl[1]}"
          @final = false
        when "FAMILY_NAME"
          puts "Font family #{bdfl[1..-1].join(" ")}"
        when "SIZE"
          puts "Font size #{bdfl[1]}px"
        when "CHARS"
          puts "#{bdfl[1]} glyphs will follow"
        when "STARTCHAR"
        when "ENDCHAR"
        when "ENDFONT"
          @final = true
        end
        # pp bdfl
      end
    end
  end
end
