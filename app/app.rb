# my_app.rb
require 'sinatra'
require 'open-uri'
require 'uri'
require 'zip'
require './split'

# sorted zipfiles look nicer
::Zip.sort_entries = true

set :bind, '0.0.0.0'

get '/' do
  erb :index
end

post '/convert/' do
  erb :convert
end

get '/convert/' do
  urls = params['midj']
  temp_dir = `mktemp -d`.chomp
  files=[]

  urls.each_line do |url|
    url.strip!
    # download file https://stackoverflow.com/a/29743469
    # avoid falling back to Kernel.open() https://stackoverflow.com/questions/263536/open-an-io-stream-from-a-local-file-or-url#comment92201328_264239
    begin
      URI.parse(url).open do |f|
        filename = File.basename(URI.parse(url).path)
        IO.copy_stream(f, "#{temp_dir}/#{filename}")
        files.append(filename)
      end
    rescue NoMethodError, URI::InvalidURIError
      # no-op
    end
  end
  if files.count == 0 then
    halt 400, 'Nothing to do.'
  end
  if files.count > 20 then
    halt 400, 'Too many requests.'
  end

  # randomized string https://codereview.stackexchange.com/a/15997
  filehash = Array.new(8){[*'0'..'9', *'a'..'z', *'A'..'Z'].sample}.join
  split_and_resize(filehash: filehash, workdir: temp_dir, images: files)

  # Zip them up
  zipfile = "#{temp_dir}/#{filehash}.zip"
  Zip::File.open(zipfile, create: true) do |zip|
    basedir = "#{temp_dir}/#{filehash}"
    Dir.glob('*', base: basedir).each do |file|
      zip.add("#{filehash}/#{file}", File.join("#{temp_dir}/#{filehash}", file))
    end
  end

  send_file zipfile, :disposition => :attachment
end
