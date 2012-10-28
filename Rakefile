require "rake/minify"

VJS_PATHS = ["src/vimify.coffee"] + Dir.glob("src/vimify/**")

Rake::Minify.new(:compile) do
  group("vimify.js") do
    VJS_PATHS.each do |file|
      add(file, minify: false, bare: true)
    end
  end

  group("vimify.min.js") do
    add("vimify.js")
  end

  group("vimify_full.min.js") do
    add("src/Keypress/keypress.js", minify: false)
    add("vimify.js")
  end
end
