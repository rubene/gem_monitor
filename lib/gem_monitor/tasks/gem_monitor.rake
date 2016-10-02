namespace :gem_monitor do

  desc "Run GemMonitor and generate report"
  task :run do |t, args|
    require 'gem_monitor'
    GemMonitor.run
  end
end
