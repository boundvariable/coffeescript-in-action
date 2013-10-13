oneMonthFromNow = new Date()
oneMonthFromNow.setMonth(oneMonthFromNow.getMonth()+1)

products =
  camera:
    'Fuji-X100':
      description: 'a camera'
      stock: 5
      arrives: oneMonthFromNow
      megapixels: 12.3,
      gallery: [
        "/images/gallery1.png"
        "/images/gallery2.png"
        "/images/gallery3.png"
      ]

  skateboard:
    'Powell-Peralta':
      description: 'a skateboard'
      stock: 3
      arrives: oneMonthFromNow
      length: "23.3 inches",
      special: 'Buy one get one free!'

  unkown:
    'Some product':
      description: 'Not sure what this is'
      stock: 100

exports.all = products