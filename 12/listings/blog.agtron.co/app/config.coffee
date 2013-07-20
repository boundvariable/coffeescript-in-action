config =
  development:
    host: 'localhost'
    port: '8080'
  production:
    host: 'blog.agtron.co'
    port: '80'

for key, value of config
  exports[key] = value

