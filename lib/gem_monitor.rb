require "gem_monitor/version"
require "gem_monitor/reader"
require "gem_monitor/gem_object"
require "gem_monitor/extractor"
require "gem_monitor/service"
require "gem_monitor/inspector"
require "gem_monitor/error"

require "colorize"
require "rest-client"
require "json"

module GemMonitor
  def self.root
    File.expand_path('../..',__FILE__)
  end

  def self.run
    begin
      GemMonitor::Inspector.new.scan
    rescue => e
      puts e.message.red
    end
  end
end
