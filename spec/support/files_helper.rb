module FilesHelper
  def delete_report_folder
    FileUtils.rm_rf GemMonitor.output_folder_name
  end
end
