require 'rack'

# most_basic_app = Proc.new do
#     ['200', {'Content-Type' => "text/html"}, ["This is the most basic app"]]
# end

# most_basic_redirect_app = Proc.new do
#     ['302', {'Content-Type' => 'text/html', 'Location' => 'https://www.google.com'}, []]
# end

# less_basic_app = Proc.new do
#     res = Rack::Response.new
#     res.write("Hello World")
#     res.finish
# end

class MyController
    def initialize(req, res)
        @req = req
        @res = res
    end

    def redirect_to(url)
        @res.status = 302
        @res.location = url
        nil
    end

    def render_content(content, content_type = "text/html")
        @res.write(content)
        @res.content_type = content_type
    end

    def execute
        if @req.path == "/cats"
            # res.write("Hello Cats")
            render_content("Hello Cats")
        elsif @req.path == "/dogs"
            # res.status = 302
            # res.location = "/cats"
            redirect_to "/cats"
        elsif @req.path == "/html"
            render_content "<strong> html is boring </strong>"
        else
            # res.write("Hello World")
            render_content("Hello World")
        end
    end
end

app = Proc.new do |environment|
    req = Rack::Request.new(environment)
    res = Rack::Response.new
    MyController.new(req, res).execute
    res.finish
end

Rack::Server.start({
    app: app,
    Port: 3000
})