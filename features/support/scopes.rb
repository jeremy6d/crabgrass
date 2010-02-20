module ScopeHelpers
  # Maps a name of a section to a CSS selector. Used by the
  #
  #   Then /^I should see \/([^\/]*)\/ within "([^\"]*)"$/ do |regexp, scope|
  #
  # step definition in webrat_steps.rb
  #
  def selector_for(scope)
    case scope

    when /the info box/
      '.info_box'
    when /the page sidebar/
      '#page_sidebar'
    when /the level 1 navigation/
      '.topnav'
    when /the level 2 navigation/
      '#second-level'
    when /the level 3 navigation/
      '#third-level'
    when /the level 4 navigation/
      '#nav4'
    when /#{capture_model}(?:'s)? row/
      thing = model!($1)
      model_name = thing.class.to_s.downcase
      "tr##{model_name}_#{thing.id}"
    else
      # use the scope as it is
      # but with surrounding quotes removed
      scope.to_s.gsub(/^['"]|['"]$/, '')
    end
  end
end

World(ScopeHelpers)
