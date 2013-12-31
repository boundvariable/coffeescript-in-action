fs = require 'fs'
compiler = require 'coffee-script'

compileClient = ->
  fs.mkdirSync "compiled/app/client" unless fs.existsSync "compiled/app/client"
  modules = fs.readFileSync "lib/modules.coffee", "utf-8"
  modules = compiler.compile modules, bare: true
  files = fs.readdirSync 'client'
  source = (for file in files when /\.coffee$/.test file
    module = file.replace /\.coffee/, ''
    fileSource = fs.readFileSync "client/#{file}", "utf-8"
    fs.writeFileSync "compiled/app/client/#{module}.js", compiler.compile fileSource
    """
    defmodule({#{module}: function (require, exports) {
      #{compiler.compile(fileSource, bare: true)}
    }});
    """
  ).join '\n\n'

  out = modules + '\n\n' + source
  fs.writeFileSync 'compiled/app/client/application.js', out

compileClient()