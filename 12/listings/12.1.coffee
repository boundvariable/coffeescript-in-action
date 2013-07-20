│                                    #A
├── app                              #B
│   ├── controllers                  #C
│   │   ├── blog.coffee
│   │   ├── controller.coffee
│   │   ├── static.coffee
│   ├── load.coffee
│   ├── models                       #C
│   │   ├── model.coffee
│   │   ├── post.coffee
│   ├── server.coffee
│   └── views                        #C
│       ├── list.coffee
│       ├── post.coffee
│       ├── view.coffee
├── content                          #D
│   ├── my-trip-to-the-circus.txt
│   └── my-trip-to-the-zoo.txt

#A The root directory for the project
#B The application directory
#C This application has models, views and controllers
#D The content directory, containing the your blog posts
