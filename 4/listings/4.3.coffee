
movie =
  title: 'From Dusk till Dawn'
  released: '1996'
  director: 'Robert Rodriguez'
  writer: 'Quentin Tarantino'

for property of movie
  console.log property

### JavaScript
var movie = {
  title: 'From Dusk till Dawn',
  released: '1996',
  director: 'Robert Rodriguez',
  writer: 'Quentin Tarantino'
}

for (var property in movie) {
  console.log(property);
}
###