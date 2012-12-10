require "rake/minify"

namespace :compile do
  Rake::Minify.new(:js) do
    group("dist/vimify.js") do
      (["src/vimify.coffee"] + Dir.glob("src/vimify/**")).each do |file|
        add(file, minify: false, bare: true)
      end
    end

    group("dist/vimify.min.js") do
      add("dist/vimify.js")
    end

    group("dist/vimify_full.min.js") do
      add("src/Keypress/keypress.js", minify: false)
      add("dist/vimify.js")
    end
  end

  desc "Compile CSS"
  task :css do
    system "sass -f -t expanded src/vimify.sass dist/vimify.css"
    system "sass -f -t compressed src/vimify.sass dist/vimify.min.css"
  end
end

desc "Compile JS and CSS"
task :compile => ["compile:js", "compile:css"]
