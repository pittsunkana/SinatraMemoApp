require 'sinatra'
require 'sinatra/reloader'
require 'haml'

get '/' do
  @memo_files=Dir.children("memos/")
  haml :index
end
get "/new" do
  haml :new
end

get "/:id" do
  @title = parse_txt_title(params['id'])
  @content = parse_txt_content(params['id'])
  haml :show
end

get "/:id/edit" do
  @title = parse_txt_title(params['id'])
  @content = parse_txt_content(params['id'])
  @id = params['id']

  haml :edit
end

put "/:id" do
  @title =params[:title]
  @content =params[:content]

  File.open("memos/#{params['id']}", "w") do |f|
    f.puts("#{@title}")
    f.puts("")
    f.puts(@content)
  end
   redirect "/#{params['id']}"
end

delete "/:id" do
  File.delete("memos/#{params['id']}")
  redirect "/"
end

post '/' do
  @title =params[:title]
  @content =params[:content]
  @time = Time.now.to_i
  new_id = generate_id

  File.open("memos/#{new_id}","w") do |f|
    f.puts("#{@title}")
    f.puts("")
    f.puts(@content)
  end
  redirect '/'
end

def generate_id
  Time.now.to_i
end

def parse_txt_title(id)
  File.open("memos/#{id}"){|f|
    p f.gets
  }
end

def parse_txt_content(id)
  File.open("memos/#{id}", mode = "rt")do |f|
    f.each_line(rs=""){|line|
      @content= line.chomp(rs="")
    }
  end
  @content
end
