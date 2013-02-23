# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

require 'bundler'

Bundler.require
require 'motion_support/all'
require 'we_the_people'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'We The People'
  app.interface_orientations = [:portrait]

  app.files_dependencies 'app/refreshable_table_view_controller.rb' => 'app/refresh_table_header_view.rb'
  app.files_dependencies 'app/petitions_controller.rb' => 'app/refreshable_table_view_controller.rb'
end
