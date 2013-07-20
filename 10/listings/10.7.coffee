dependencies =                                      #A
  'Tracking': '../tracking'                         #A
  'User': '../user'                                 #A
  'fact': '../fact'

for dependency, path of dependencies                #A
  exports[dependency] = require(path)[dependency]   #A
