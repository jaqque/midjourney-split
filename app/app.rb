# my_app.rb
require 'sinatra'
require 'open-uri'
require 'uri'

set :bind, '0.0.0.0'

get '/' do
  erb :index
end

get '/convert/' do
  # redirect to("/dl/#{params['midj']}")
  url = params['midj']
  filename = File.basename(URI.parse(url).path)
  # https://stackoverflow.com/a/29743469
  temp_dir = `mktemp -d`.chomp
  #  File.basename(URI.parse(u).path)
  #download = URI.open(url)
  #IO.copy_stream(download, "#{temp_dir}/#{filename}")
  #download.close
  # https://stackoverflow.com/questions/263536/open-an-io-stream-from-a-local-file-or-url#comment92201328_264239
  URI.parse(url).open do |f|
    IO.copy_stream(f, "#{temp_dir}/#{filename}")
  end
  # random string: ('a'..'z').to_a.shuffle[0,8].join
  # or require 'securerandom' ; SecureRandom.hex(4) for 8 hex digits
  # or require 'securerandom' ; srand; Random.hex(4)  
  # https://codereview.stackexchange.com/a/15965
  # or 8.times.map { [*'0'..'9', *'a'..'z', *'A'..'Z'].sample }.join
  # https://codereview.stackexchange.com/a/15997
  # ([nil]*8).map { ((48..57).to_a+(65..90).to_a+(97..122).to_a).sample.chr }.join
  # Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
  filehash = Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
  zipfile = `/app/split.sh "#{temp_dir}/#{filename}" "#{filehash}"`.chomp
  send_file zipfile
  # erb :convert
end

get '/dl/*' do
  sleep 5
  "done with #{params["splat"]}"
end

get '/test' do
  stream do |out|
    out << "It's gonna be legen -\n"
    sleep 0.5
    out << " (wait for it) \n"
    sleep 1
    out << "- dary!\n"
  end
end

__END__

@@ index
<!DOCTYPE html>
<html>
<head>
<title>Ninja Slice | Serving Up Tasty Eats</title>
<meta charset="utf-8">
    <link rel="stylesheet"
          href="https://fonts.googleapis.com/css?family=Comic Neue">
<style>
body {
font-family: Comic Neue;
background-color: black;
}

h1 {
color: white;
text-align: center;
text-transform: uppercase;
font-size: 60px;
}

h2 {
color: purple;
text-align: center;
font-size: 30px;
margin: 25px;
}

img {
  display: block;
  margin-left: auto;
  margin-right: auto;
  width: auto;
}

input[type=text], select {
  width: 100%;
  padding: 12px 20px;
  margin: 8px 0;
  display: block;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
}

input[type=submit] {
  width: 100%;
  background-color: purple;
  color: white;
  padding: 14px 20px;
  margin: 8px 0;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-family: Comic Neue;
  font-size: 20px;
}

input[type=submit]:hover {
  background-color: #e6b800;
  font-family: Comic Neue;
}

div.container {
  border-radius: 5px;
  background-color: #f2f2f2;
  padding: 20px;
}

</style>
</head>
<body>
<img src="ninja-slice-header-v<% rand(1..3) %>.png" alt="Ninja Slice Ultimate" width="940" height="180">

<h2>Enter your MidJourney link below.</h2>

<div class="container">
  <form action='/convert/'>
    <label for='midj'>URI of Midjourney Image:</label>
  <input type='text' id='midj' name='midj'>

    <input type="submit" value="Submit">
  </form>

</div>
Introducing "Ninja Slice Ultimate" - Your Ultimate Image Enhancement Solution!

Unlock the power of professional image processing with Ninja Slice Ultimate, the cutting-edge online software tool designed to transform your Midjourney 4-up images into stunning high-resolution masterpieces. Elevate your visuals effortlessly and prepare them for top-quality printing like never before.

Features:

Precise Slicing: Ninja Slice Ultimate effortlessly divides your Midjourney 4-up images into four individual, finely crafted segments, preserving every detail with pinpoint precision.

Seamless Upscaling: Witness the magic of advanced upscaling technology as Ninja Slice Ultimate enlarges each segmented image while maintaining exquisite clarity and sharpness. Your images will be ready for large-scale printing without compromise.

Optimized for Printing: With Ninja Slice Ultimate, you can rest assured that your images are primed for the highest quality print results. Every segment is enriched with vibrant colors and lifelike details, ensuring your artwork comes to life on paper.

User-Friendly Experience: Enjoy a streamlined process that makes image enhancement accessible to everyone. With its intuitive interface, Ninja Slice Ultimate lets you effortlessly upload, process, and download your perfected images in moments.

Automatic Zipping: Your convenience is our priority. Ninja Slice Ultimate automatically compresses your processed images into a convenient zip file, ensuring a quick and efficient download experience.

Ready for Action: Ninja Slice Ultimate delivers the results directly to you. Once your images are processed, they are immediately ready for download via your browser, saving you time and effort.

Embrace the transformational capabilities of Ninja Slice Ultimate and witness your Midjourney 4-up images evolve into captivating artworks, perfectly tailored for printing. Elevate your imagery with ease and precision. Get started today - it's time to bring your visuals to life like never before!

Notice of Non-Affiliation and Disclaimer

We are not affiliated, associated, authorized, endorsed by, or in any way officially connected with Midjourney, or any of its subsidiaries or its affiliates. The official Midjourney website can be found at https://www.midjourney.com/.

The name Midjourney as well as related names, marks, emblems and images are registered trademarks of their respective owners.

Free Software Disclaimer

This program is free software. It comes without any warranty, to the extent permitted by applicable law. You can redistribute it and/or modify it under the terms of Attribution 4.0 International (CC BY 4.0) https://creativecommons.org/licenses/by/4.0/

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
</body>
</html>

@@ convert
<html>
<title>busy</title>
<body>
  <p>busy.</p>
  <p>gotta deal with <%= params['midj'] %></p>
</body>
</html>
