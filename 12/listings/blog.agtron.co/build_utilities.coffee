fs = require 'fs'
{spawn, exec, execFile, fork} = require 'child_process'    #A

client_compiled = false

for_all_specs_in = (dir, fn) ->                           #B
  execFile 'find', [ dir ], (err, stdout, stderr) ->      #B
    file_list = stdout.split '\n'                         #B
    for file in file_list                                 #B
      fn file if /_spec.js$/.test file                    #B

compile_client = (callback) ->
  return callback() if client_compiled                              #C
  client_compiled = true                                            #C
  compiler = require 'coffee-script'                                #C
  modules = fs.readFileSync "lib/modules.coffee", "utf-8"           #C
  modules = compiler.compile modules, bare: true                    #C
  files = fs.readdirSync 'client'                                   #C

  fs.mkdirSync "compiled/app/client"
  source = (for file in files when /\.coffee$/.test file            #C
    module = file.replace /\.coffee/, ''                            #C
    file_source = fs.readFileSync "client/#{file}", "utf-8"         #C
    fs.writeFileSync "compiled/app/client/#{module}.js", compiler.compile file_source
    """
    defmodule({#{module}: function (require, exports) {
      #{compiler.compile(file_source, bare: true)}
    }});
    """                                                             #C
  ).join '\n\n'                                                     #C

  out = modules + '\n\n' + source                                   #C
  fs.writeFileSync 'compiled/app/client/application.js', out        #C

  callback?()

compile = (path, callback) ->
  coffee = spawn 'coffee', ['-c', '-o', "compiled/#{path}", path]

  coffee.on 'exit', (code, s) ->
    if code is 0 then compile_client callback
    else console.log 'error compiling'

  coffee.on 'message', (data) ->
   console.log data

create_artifact = (path, version, callback) ->                           #D
  execFile "tar", ["-cvf", "artifact.#{version}.tar", path], (e, d) ->   #D
    callback?()                                                          #D

run_specs = (folder) ->
  for_all_specs_in folder, (file) ->
    require "./#{file}"

clean = (path, callback) ->
  exec "rm -rf #{path}", -> callback?()

copy = (src, dst, callback) ->
  exec "cp -R #{src} #{dst}/.", ->
    callback?()

run_app = (env) ->
  exec 'NODE_ENV=#{env} node compiled/app/server.js &', ->   #F
    console.log "Running..."

exports.clean = clean
exports.compile = compile
exports.copy = copy
exports.create_artifact = create_artifact
exports.run_specs = run_specs
exports.run_app = run_app