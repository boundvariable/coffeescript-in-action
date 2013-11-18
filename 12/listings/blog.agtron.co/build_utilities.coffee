fs = require 'fs'
{spawn, exec, execFile, fork} = require 'child_process'    #A

clientCompiled = false

forAllSpecsIn = (dir, fn) ->                              #B
  execFile 'find', [ dir ], (err, stdout, stderr) ->      #B
    fileList = stdout.split '\n'                          #B
    for file in fileList                                  #B
      fn file if /_spec.js$/.test file                    #B

compileClient = (callback) ->
  return callback() if clientCompiled                               #C
  clientCompiled = true                                             #C
  compiler = require 'coffee-script'                                #C
  modules = fs.readFileSync "lib/modules.coffee", "utf-8"           #C
  modules = compiler.compile modules, bare: true                    #C
  files = fs.readdirSync 'client'                                   #C

  fs.mkdirSync "compiled/app/client"
  source = (for file in files when /\.coffee$/.test file            #C
    module = file.replace /\.coffee/, ''                            #C
    fileSource = fs.readFileSync "client/#{file}", "utf-8"          #C
    fs.writeFileSync "compiled/app/client/#{module}.js", compiler.compile fileSource
    """
    defmodule({#{module}: function (require, exports) {
      #{compiler.compile(fileSource, bare: true)}
    }});
    """                                                             #C
  ).join '\n\n'                                                     #C

  out = modules + '\n\n' + source                                   #C
  fs.writeFileSync 'compiled/app/client/application.js', out        #C

  callback?()

exports.fromDir = (root) ->

  return unless root

  compile = (path, callback) ->
    coffee = spawn 'coffee', ['-c', '-o', "#{root}compiled/#{path}", path]

    coffee.on 'exit', (code, s) ->
      if code is 0 then compileClient callback
      else console.log 'error compiling'

    coffee.on 'message', (data) ->
     console.log data

  createArtifact = (path, version, callback) ->                            #D
    execFile "tar", ["-cvf", "artifact.#{version}.tar", path], (e, d) ->   #D
      callback?()                                                          #D

  runSpecs = (folder) ->
    forAllSpecsIn "#{root}#{folder}", (file) ->
      require "./#{file}"

  clean = (path, callback) ->
    exec "rm -r #{root}#{path}", (err) -> callback?()

  copy = (src, dst, callback) ->
    exec "cp -R #{root}#{src} #{root}#{dst}/.", ->
      callback?()

  runApp = (env) ->
    exec 'NODE_ENV=#{env} nohup node compiled/app/server.js &', ->
      console.log "Running..."

  {clean, compile, copy, createArtifact, runSpecs, runApp}
