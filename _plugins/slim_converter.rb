#module Jekyll
  #class SlimConverter < Converter
    #safe true

    #def setup
      #return if @setup
      #require 'slim'
      #@setup = true
    #rescue
      #STDERR.puts 'do `gem install slim`'
      #raise FatalException.new("Missing dependency: slim")
    #end

    #def matches(ext)
      #ext =~ /slim/i
    #end

    #def output_ext(ext)
      #".html"
    #end

    #def convert(content)
      #setup
      #engine = Slim::Engine.new(content)
      #engine.render
    #end
  #end
#end
