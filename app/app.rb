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
<html>
<title>convert</title>
<body>
<form action='/convert/'>
  <label for='midj'>URI of Midjourney Image:</label>
  <input type='text' id='midj' name='midj'>
</form>
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
