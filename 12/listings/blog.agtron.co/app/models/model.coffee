
class Model
  dirify: (s) -> s.toLowerCase().replace /[^a-zA-Z0-9-]/gi, '-'

exports.Model = Model
