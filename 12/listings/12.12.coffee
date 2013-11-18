
# This needs to be in a Cakefile.
# See the final Cakefile for a complete listing
# of all the tasks for the application

compile (directory) = ->                                                      #A
  coffee = spawn 'coffee', ['-c', '-o', "compiled/#{directory}", directory]   #A
                                                                              #A
coffee.on 'exit', (code) ->                                                   #A
  console.log 'Build complete'                                                #A

clean = (path, callback) ->                  #B
  exec "rm -rf #{path}", -> callback?()      #B

forAllSpecsIn = (dir, fn) ->                           #C
  execFile 'find', [ dir ], (err, stdout, stderr) ->   #C
    fileList = stdout.split '\n'                       #C
    for file in fileList                               #C
      fn file if /_spec.js$/.test file                 #C

runSpecs = (folder) ->                  #D
  forAllSpecsIn folder, (file) ->       #D
    require "./#{file}"                 #D

task 'build', 'Compile the application', ->        #E
  clean 'compiled', ->                             #E
    compile 'app', ->                              #E
      'Build complete'                             #E

task 'test' , 'Run the tests', ->         #F
  clean 'compiled', ->                    #F
    compile 'app', ->                     #F
      compile 'spec', ->                  #F
        runSpecs 'compiled', ->           #F
          console.log 'Tests complete'    #F
#A Compile function that takes a directory from which it should compile files
#B A clean function that deletes a directory
#C Invoke a function for all the _spec.js files in a directory
#D Run the specs by passing a function that requires a test to forAllSpecsIn
#E The build task cleans then compiles
#F The test task cleans and compiles the app, then cleans and compiles the tests, then runs the tests
