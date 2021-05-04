module Arask
  class Railtie < ::Rails::Railtie
    # Executes when the rails server is running
    server do
      Arask.init_jobs
    end if Rails::VERSION::MAJOR>=6
  end
end
