module Jekyll
  module Filters
    def mark_excerpt(content)
      content.sub(@context.environments.first['site']['excerpt_separator'], '<span id="more"></span>')
    end

    def take(array, num = 10)
      array.take num
    end

    def fake_pager(site, posts)
      class << site
        def config; self; end
      end
      Pager.new site, 1, posts
    end

    def sort_by_size(collection, dir = 'desc')
      sorted = collection.sort {|a,b| b[1].size <=> a[1].size}

      dir == 'desc' ? sorted : sorted.reverse
    end

    def sort_by_name(collection, dir = 'asc')
      sorted = collection.sort {|a,b| a[0] <=> b[0]}

      dir == 'asc' ? sorted : sorted.reverse
    end
  end
end
