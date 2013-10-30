module Jekyll

  class GroupPageGenerator < Generator
  
    safe true

    def generate(site)
      site.categories.each do |name, posts|
        build_subpages(site, "category", name, posts)
      end

      site.tags.each do |name, posts|
        build_subpages(site, "tag", name, posts)
      end
    end

    def build_subpages(site, type, name, posts)
      posts = posts.sort_by { |p| -p.date.to_f }
      atomize(site, type, name, posts)
      paginate(site, type, name, posts)
    end

    def atomize(site, type, name, posts)
      dir = GroupBasePage.type_dir site, type, name
      atom = AtomPage.new(site, site.source, dir, type, name, posts)
      site.pages << atom
    end

    def paginate(site, type, name, posts)
      pages = Pager.calculate_pages(posts, site.config['paginate'].to_i)
      (1..pages).each do |num_page|
        path = GroupBasePage.type_dir site, type, name, num_page
        newpage = GroupPage.new(site, site.source, path, type, name)
        newpage.pager = GroupPager.new(site, num_page, posts, type, name, pages)

        site.pages << newpage
      end
    end
  end

  class GroupBasePage < Page

    def initialize(site, base, dir, type, val)
      @site = site
      @base = base
      @dir = dir

      self.process(@name)
      template = "#{template_name(site, type, val)}#{File.extname(@name)}"
      self.read_yaml(File.join(base, '_layouts'), template)
      self.data["grouptype"] = type
      self.data[type] = val

      title_prefix = site.config["#{type}_title_prefix"] || "#{type.capitalize}: "
      self.data['title'] = "#{title_prefix}#{val}"

      self.data['feed_path'] = dir
    end

    def template_name(site, type, name)
      [site.config["#{name}_#{type}_#{@template_type}_layout"],
        site.config["#{type}_#{@template_type}_layout"], 
        site.config["group_#{@template_type}_layout"],
        "group_#{@template_type}"
      ].compact.each do |layout|
        return layout if site.layouts.key?(layout)
      end
      nil
    end

    def self.type_basedir(site, type)
      config = site.respond_to?(:config) ? site.config : site
      Pager.ensure_leading_slash(config["#{type}_dir"] || type)
    end

    def self.type_dir(site, type, name, page_num = 1)
      config = site.respond_to?(:config) ? site.config : site
      dir = File.join(type_basedir(site, type), name.to_url)
      page_name = File.basename config['paginate_path']
      dir = File.join(dir, page_name.sub(':num', page_num.to_s)) if page_num > 1
      Pager.ensure_leading_slash dir
    end
  end

  class GroupPage < GroupBasePage
    def initialize(site, base, dir, type, val)
      @template_type = 'page'
      @name = 'index.html'
      super
    end
  end
  
  class AtomPage < GroupBasePage
    def initialize(site, base, dir, type, val, posts)
      @template_type = 'atom'
      @name = 'atom.xml'
      super site, base, dir, type, val

      show_posts = (site.config['feed_posts'] || posts.count).to_i
      self.data["posts"] = posts.take(show_posts)
    end
  end

  class GroupPager < Pager
    def self.pagination_enabled?(site, type, name)
      GroupBasePage.template_name(site, type, name) && !site.config['paginate'].nil?
    end

    def initialize(site, page, all_posts, type, name, num_pages = nil)
      super site, page, all_posts, num_pages

      @base_path = GroupBasePage.type_dir site, type, name
      @previous_page_path = GroupBasePage.type_dir site, type, name, @previous_page if @previous_page
      @next_page_path = GroupBasePage.type_dir site, type, name, @next_page if @next_page
    end
  end

  class Pager
    attr_accessor :base_path

    alias_method :old_to_liquid, :to_liquid
    def to_liquid
      h = old_to_liquid
      h['base_path'] = (base_path || '/')
      h
    end
  end

  module Filters
    def category_url(cat)
      GroupBasePage.type_dir @context.environments.first['site'], 'category', cat
    end

    def tag_url(tag)
      GroupBasePage.type_dir @context.environments.first['site'], 'tag', tag
    end

    def page_url(path, page = 1)
      site = @context.environments.first['site']
      page_name = File.basename site['paginate_path']
      path = File.dirname site['paginate_path'] if path == '/' && page > 1
      path = File.join(path, page_name.sub(':num', page.to_s)) if page > 1
      path
    end
  end
end
