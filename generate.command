#! /usr/bin/ruby -r yaml -r json -r pathname
require "active_support/core_ext"

ARGV.push "#{__dir__}/dracula.yml" unless ARGF.pos.zero?

theme = YAML.load ARGF.read
theme.delete "spec"
theme.deep_transform_values! do |value|
  next value if value.in? [true, false]
  value = value.to_s
  value.prepend "#" if value.match? /^\h{3,6}$/
  value
end

return puts JSON.pretty_generate theme unless STDIN.tty?

name = theme["name"].titlecase

yml = Pathname ARGF.filename
File.write "#{yml.dirname/name}.draftsTheme", theme.to_json
