=begin

Methods to find pages, for class Page.

find_and_paginate_by_path()
this is the wiz-bang main function for finding and paginating pages.
see find_pages() if you don't need to paginate.
we are paginating pages, so the term page is ambiguous.
it could mean a Page from the pages table, or it could mean a page of things
when paginating. i have tried to use the term 'section' instead of a page for the latter.

=end

module PathFinder
  module FindByPath
  
    def find_and_paginate_by_path(path, options={})
      options = apply_possible_lambda(path, options)

      pages_per_section = options[:section_size] || ::SECTION_SIZE
      current_section   = options[:section] || 1
      offset            = (current_section - 1) * pages_per_section 
      controller        = options[:controller]
      
      options[:limit]   = pages_per_section
      options[:offset]  = offset
      options[:method] ||= :sql
      if !sphinx_running?
        options[:method] = :sql
      end

      #puts options[:values].inspect
      pages = PathFinder::Builder.find_pages(options[:method], path, options)
      #puts options[:values].inspect
      count = count_by_path(path, options.dup.merge(:offset => nil, :limit => nil))  
      page_sections = ActionController::Pagination::Paginator.new(
        controller, count, pages_per_section, current_section
      )
      
      [pages, page_sections]
    end
    alias :paginate_by_path :find_and_paginate_by_path
    
    def count_by_path(path, options={})
      options = apply_possible_lambda(path, options)

      PathFinder::Builder.count_pages(:sql, path, options)
    end
    
    def find_by_path(path, options={})
      options = apply_possible_lambda(path, options)

      if options[:paginate] or options[:section] or options[:section_size]
        find_and_paginate_by_path(path, options)
      else
        options[:method] ||= :sql
        PathFinder::Builder.find_pages(options[:method], path, options)
      end
    end

    # if the options argument is really a lambda, then call the lambda with
    # the path to get the real options hash    
    def apply_possible_lambda(path, options)
      if options.is_a? Proc
        options.call( PathFinder::Builder.parse_filter_path(path) )
      else
        options
      end
    end

  end # FindByPath
end # PathFinder

