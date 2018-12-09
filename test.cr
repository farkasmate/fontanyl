#!/usr/bin/env crystal

require "./src/fontanyl"

font = Fontanyl::BDF.new("font.bdf")

def gets(font : Fontanyl::Font, msg : String)
  stra = Array(String).new(17) { "" } # hack
  msg.chars.each do |c|
    char = font.get(c)
    char.bitmap.each_slice(char.width).with_index { |e, ei| e.each { |i| stra[ei] = stra[ei] + (i ? '#' : ' ') }; stra[ei] += "  " }
  end
  stra.join("\n")
end

puts gets(font, "TEST")
