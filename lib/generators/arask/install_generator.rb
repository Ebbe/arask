require 'rails/generators'
require "rails/generators/active_record"

class Arask::InstallGenerator < Rails::Generators::Base
  def initialize(*args, &block)
    super

    Arask::InstallGenerator.source_root File.expand_path('../../arask', __FILE__)
    copy_file '../../arask/initialize.rb', 'config/initializers/arask.rb'

    generate 'migration', 'create_arask_jobs job:string execute_at:datetime:index interval:string'
  end
end
