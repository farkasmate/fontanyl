#!/usr/bin/env crystal

require "./src/fontanyl"

font = Fontanyl::BDF.new("font.bdf")

def render(bitmap)
  bitmap.each do |line|
    line.each { |e| puts e.map { |i| i ? '#' : ' ' }.join }
  end
end

puts "Test 1"
render font.get_bitmap("Test 1")

puts "Linewrap"
render font.get_bitmap("Linewrap", 4)
