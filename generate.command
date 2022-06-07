#! /usr/bin/ruby -r yaml -r json -r pathname
require "active_support/all"

class String
  def to_p
    Pathname self
  end
end

curl = "curl --location --silent"
branch = "d07898c20cf6fc71fa77f5c1c282bc9f70411bc0" #master
base = `#{curl} https://raw.githubusercontent.com/dracula/template/#{branch}/Dracula.yml`


theme = YAML.load base + yml.read
yml = ARGF.pos.zero? ? "#{__dir__}/dracula.yml".to_p : ARGF.dup
theme.delete "spec"
theme.deep_transform_values! do |value|
  next value if value.in? [true, false]
  value = value.to_s
  value.prepend "#" if value.match? /^\h{3,6}$/
  value
end

return puts JSON.pretty_generate theme unless STDIN.tty?

name = theme["name"].titlecase
ext = "#{__dir__}/.gitignore".to_p.readlines.last.chomp.to_p.extname

(ARGF.path.to_p.dirname/name).sub_ext(ext).write theme.to_json
