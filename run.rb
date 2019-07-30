require 'inputs'
require 'irb'
require 'securerandom'
require 'fileutils'
require 'mini_magick'
require 'pathname'
require 'colorize'
require 'piet'


def source_folder
  @source_folder ||= begin
    if ENV['DEFAULTS'] || Inputs.yn('use the default "/tmp/shrink" folder ?')
      FileUtils.mkdir('/tmp/shrink') unless Dir.exist?('/tmp/shrink')
      s = '/tmp/shrink'
    else
      s = Inputs.name "Specify source folder"
    end
    raise "source folder don't exist" unless Dir.exist?(s)
    puts "Using folder #{s} as a source folder (make sure images for convert are there)".red
    s
 end
end

def destination_folder
  @destination_folder ||= begin
    if ENV['DEFAULTS'] || Inputs.yn('use the default destination "/tmp/shrink_processed" folder ?')
      d = '/tmp/shrink_processed'.tap { |dest| FileUtils.mkdir(dest) unless Dir.exist?(dest) }
    else
      d = Inputs.name "destination folder"
      raise "destination folder don't exist" unless Dir.exist?(d)
      raise "cannot be the same" if source_folder == d
      d
    end
    puts "Using folder #{d} as a destination folder".red
    d
  end
end

def default_size
  "1600x1200>"
end

def size
  @size ||= if Inputs.yn "Use default size #{default_size} ?"
              default_size
            else
              Inputs.name "specify Minimagic suported size"
            end
end

def resize_image(file)
  path = Pathname.new(file)
  puts(path)

  if should_use_rand_name
    destination_path_image = "#{destination_folder}/#{SecureRandom.hex(5)}#{path.extname.to_s.downcase}"
  else
    destination_path_image = "#{destination_folder}/#{path.basename.to_s.downcase}"
  end

  case path.extname.to_s.downcase
  when '.jpg', '.jpeg', '.png'
    image = MiniMagick::Image.open(path.to_s)
    image.resize  size
    image.crop(crop_dimension) if crop_dimension
    image.write  destination_path_image
    destination_path_image
  when '.gif'
    puts "  Warning !! '.gif' file is just copied".yellow
    FileUtils.cp(path, destination_path_image)
  else
    puts "  Warning !! file is not '.jpg' nor '.png'".yellow
    nil
  end
end

def should_use_rand_name
  return @should_use_rand_name unless @should_use_rand_name.nil?
  @should_use_rand_name = Inputs.yn('Do you want to rename files randomly?')
end

def web_optimize(file)
  Piet.optimize(file, quality: 90, level: 7)
end

def crop_dimension
  return @crop_dimension unless @crop_dimension.nil?
  @crop_dimension = Inputs.yn "do you want to crop ?"
  @crop_dimension = Inputs.name('specify crop dimesnions eg.:  200x800+0+0') if @crop_dimension
  @crop_dimension
end


size
source_folder
destination_folder

if Inputs.yn('remove old files in destination_folder ?')
  Dir.glob("#{destination_folder}/*").each { |f| puts("removing #{f}".yellow); FileUtils.rm(f) }
end
optimize = Inputs.yn "do you want web optimize?"


puts "\n\n resising files from #{source_folder} to #{destination_folder} ".green

Dir.glob("#{source_folder}/**/*").each do|f|
  img_path = resize_image(f)
  web_optimize(img_path) if img_path && optimize
end


puts "Finished"
Dir.glob("#{destination_folder}/**/*").each { |f| puts f }

