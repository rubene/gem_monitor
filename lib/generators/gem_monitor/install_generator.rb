module GemMonitor
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Create gem_monitor files"
      require "fileutils"

      def create_taks_file
        app_task_path = File.join("lib", "tasks", "gem_monitor.rake")
        if File.exist? app_task_path
          puts "Task file already exists"
        else
          puts "Creating task file"
          FileUtils.cp "#{GemMonitor.root}/lib/gem_monitor/tasks/gem_monitor.rake", app_task_path
        end
      end

      def add_files_to_gitignore
        gitignore_content = "/gem_monitor/"
        gitignore_file_path = File.join(".gitignore")
        if File.exist? gitignore_file_path
          gitignore_file_content = GemMonitor::Reader.new(file_path: gitignore_file_path).read
          if gitignore_file_content.include? gitignore_content
            puts "Report files are already added to the gitignore file"
          else
            puts "Adding report files to the gitignore file"
            open(gitignore_file_path, "a") do |f|
              f.puts gitignore_content
            end
          end
        end
      end
    end
  end
end
