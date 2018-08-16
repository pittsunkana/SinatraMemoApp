require "sinatra"
require "sinatra/reloader"
require "haml"
require "securerandom"

get "/" do
  @file_names = Dir.children("memos/").sort
  haml :index
end
get "/new" do
  haml :new
end

get "/:id" do
  @id = params["id"]
  @title = extract_title(@id)
  @content = extract_content(@id)
  haml :show
end

get "/:id/edit" do
  @id = params["id"]
  @title = extract_title(@id)
  @content = extract_content(@id)

  haml :edit
end

post "/" do
  @title = params[:title]
  @content = params[:content]
  new_id = generate_id

  File.open("memos/#{new_id}", "w") do |f|
    f.puts("#{@title}")
    f.puts("")
    f.puts(@content)
  end
  redirect "/"
end

patch "/:id" do
  @title = params[:title]
  @content = params[:content]

  File.open("memos/#{params["id"]}", "w") do |f|
    f.puts("#{@title}")
    f.puts("")
    f.puts(@content)
  end
  redirect "/#{params["id"]}"
end

delete "/:id" do
  File.delete("memos/#{params["id"]}")
  redirect "/"
end

def generate_id
  "#{Time.now.to_i}-" + "#{SecureRandom.uuid}"
end

def array_to_text(id)
  text_array = ""
  File.open("memos/#{id}", "r") do |f|
    text_array = f.read.split("\n\n")
  end
  text_array
end

def extract_title(id)
  array_to_text(id).first
end

def extract_content(id)
  array_to_text(id).last
end

helpers do
  def nl_to_br(content)
    content.include?("\n") ? content.gsub(/(\r\n|\r|\n)/, "<br />") : return
  end
end
