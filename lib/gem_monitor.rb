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
  class << self
    attr_accessor :configuration
  end

  def self.configure
    yield(configuration)
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  class Configuration
    attr_accessor :gemfile_path, :gemfile_lock_path

    def initialize
      @gemfile_path = "Gemfile"
      @gemfile_lock_path = "Gemfile.lock"
    end
  end

  def self.root
    File.expand_path('../..',__FILE__)
  end

  def self.main_url
    "https://github.com/rubene/gem_monitor"
  end

  def self.issues_url
    "#{main_url}/issues"
  end

  def self.report_erb_template
    "#{root}/lib/gem_monitor/templates/index.html.erb"
  end

  def self.report_file_path
    "#{output_folder_name}/#{File.basename(report_erb_template, ".erb")}"
  end

  def self.output_folder_name
    "gem_monitor"
  end

  def self.run
    begin
      GemMonitor::Inspector.new.scan
    rescue => e
      puts e.message.red
    end
  end
end
