http = require 'http'
{load} = require './load'
{Blog} = require './controllers'

load './content'

throw new Error 'No evironment defined' unless process.env.NODE_ENV

config = require('./config')[process.env.NODE_ENV]

process.exit() unless config?

server = new http.Server()
server.listen config.port, config.host

blog = new Blog server
