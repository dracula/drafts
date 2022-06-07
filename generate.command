#! /usr/bin/ruby -r yaml -r json -r pathname
require "active_support/core_ext/hash"

ARGV.push "#{__dir__}/dracula.yml" unless ARGF.pos.zero?

theme = YAML.load ARGF.read
theme.delete "spec"
theme.deep_transform_values! do |value|
  value.prepend "#" if value.match? /^\h{6,8}$/
  value
end

return puts JSON.pretty_generate theme unless STDIN.tty?

require "active_support/inflector"
name = theme["name"].titlecase

yml = Pathname ARGF.filename
File.write "#{yml.dirname/name}.json", theme.to_json
