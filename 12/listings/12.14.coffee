
# This task belongs to a Cakefile. See the final Cakefile for the
# complete tasks for the application.

task 'build:client', 'build client side stuff with modules', ->
  compiler = require 'coffee-script'
  modules = fs.readFileSync "lib/modules.coffee", "utf-8"     #A

  modules = compiler.compile modules, bare: true              #B
  files = fs.readdirSync 'client'
  source = (for file in files when /\.coffee$/.test file
    module = file.replace /\.coffee/, ''
    fileSource = fs.readFileSync "client/#{file}", "utf-8"    #C
    """
    defmodule({#{module}: function (require, exports) {
      #{compiler.compile(fileSource, bare: true)}
    }});
    """                                                        #D
  ).join '\n\n'    #E

  out = modules + '\n\n' + source
  fs.writeFileSync 'compiled/app/client/application.js'   #F
#A lib/modules.coffee contains the code from listing 13.13
#B CoffeeScript is compiled bare. Meaning that there is no outer function wrapper
#C As this is in the build where you don’t care about blocking - readFileSync is acceptable.
#D The actual file output is the compiled CoffeeScript wrapped in the defmodule call.
#E All of the modules are concatenated with a simple join
#F Write the entire compiled application to application.js
