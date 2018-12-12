# fontanyl

bitmap font parser

## Installation

1. Add the dependency to your `shard.yml`:
```yaml
dependencies:
  fontanyl:
    github: fliegermarzipan/fontanyl
```
2. Run `shards install`

## Usage

```crystal
require "fontanyl"


def render(bitmap)
  # The generated bitmap is an array of lines-of-text
  bitmap.each do |line|
    # Each text line contains several Y-scanlines
    # as an Array(Bool) bitmap
    line.each { |e| puts e.map { |i| i ? '#' : ' ' }.join }
  end
end

# Load BDF font from file
font = Fontanyl::BDF.new("font.bdf")

# Generate bitmap of string using loaded font
# and pass it to our render() function that maps the bits
# to ascii-art text
render font.get_bitmap("Hello, World")
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/fliegermarzipan/fontanyl/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Robin Broda](https://github.com/coderobe) - creator and maintainer
