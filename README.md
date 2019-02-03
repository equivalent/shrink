# Shrink

This terrible piece of Ruby code is a script that to resize
images.

For example:

*  I use it to copy all my "memory" photos in high resolution to a Foto Frame (low res)
(tablet running foto slideshow)
* I use it when I want to web-optimize bunch of images for static page

### Docker:

Simplest usage is just clone the repo and run `docker-compose up`

https://cloud.docker.com/repository/registry-1.docker.io/equivalent/shrink


### Ruby script:

If you want to run it as a Ruby script in your computer:

1. `sudo apt install imagemagick libmagickcore-dev libmagickwand-dev libmagic-dev jpegoptim optipng`
2. git clone
3. bundle install
4. ruby run.rb


> No tests as I'm not planing to make this "popular" project and for my every day use it just works withot tests


