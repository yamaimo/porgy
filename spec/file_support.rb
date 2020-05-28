require 'fileutils'
require 'pathname'

module FileSupport
  def get_data_dir
    Pathname.new(__dir__) + 'data'
  end

  def get_data_path(filename)
    get_data_dir + filename
  end

  def get_output_dir(dirname=nil, clean: false)
    output_dir = Pathname.new(__dir__) + 'output'
    output_dir += dirname unless dirname.nil?
    FileUtils.remove_entry_secure(output_dir) if output_dir.exist? && clean
    FileUtils.makedirs(output_dir) unless output_dir.exist?
    output_dir
  end

  module_function :get_data_dir, :get_data_path, :get_output_dir
end
