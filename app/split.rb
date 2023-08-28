#!/usr/bin/ruby

require 'rmagick'
require 'fileutils'

def split_and_resize (workdir:, images:, filehash:)

  filter=Magick::SincFilter
  corners = [
    Magick::NorthWestGravity,
    Magick::NorthEastGravity,
    Magick::SouthWestGravity,
    Magick::SouthEastGravity,
  ]
  output_formats = [
    'png',
    'jpg',
  ]

  Dir.mkdir("#{workdir}/#{filehash}")

  images.each_with_index do |image, counter|
    c=sprintf('%02d', counter + 1) # index, not offset

    img = Magick::ImageList.new("#{workdir}/#{image}")

    img[0].units=Magick::PixelsPerInchResolution
    img[0].density='300'

    input_x=img[0].columns/2 # 1024
    input_y=img[0].rows/2
    output_x = input_x * 4   # 4096
    output_y = input_y * 4

    corners.each_with_index do |corner, index|
      output=img.crop(corner, input_x, input_y)
      output.resize!(output_x, output_y, filter=filter)
      output_formats.each do |format|
        output.write("#{workdir}/#{filehash}/IMG_#{filehash}-#{c}-#{index}.#{format}")
      end
    end
    FileUtils.mv("#{workdir}/#{image}", "#{workdir}/#{filehash}/IMG_#{filehash}-#{c}" + File.extname(image))
  end
end
