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
<img src="https://whimberrypress.com/wp-content/uploads/2023/08/ninja-slice.png" alt="ninja-slice" width="512" height="512">
<img src="https://whimberrypress.com/wp-content/uploads/2023/08/Ninja-Slice-Ultimate.gif" alt="ninja-slice" width="1258" height="250">

<h2>Enter your MidJourney link below.</h2>

<div class="container">
  <form action='/convert/'>
    <label for='midj'>URI of Midjourney Image:</label>
  <input type='text' id='midj' name='midj'>

    <input type="submit" value="Submit">
  </form>

</div>
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
