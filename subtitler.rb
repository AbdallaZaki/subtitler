require_relative 'file_validator'
class Subtitler
  attr_reader :dir , :files
  @@files_array = []
  @@supported_formats = /.(srt|txt)$/
  def initialize args
    @files=args[:files]
    @dir=args[:dir]
  end
  def marge

  end
  def show
    fetch_subtitle_files
    select_files get_margable_files_type?
    @@files_array
  end
  private
  def select_files files_ext
    if !files_ext.nil?
      @@files_array=@@files_array.reject{|file| file if (/#{Regexp.escape(files_ext)}$/.match(file)).nil? }
    end
  end
  def get_margable_files_type?
    files_ext_hsh=@@files_array.inject(Hash.new(0)) { |hash , file_name | hash[(get_file_extension file_name)] +=1 ; hash }.sort_by { |key , val| val }
    files_ext_hsh.last[1] >= 2 ? files_ext_hsh.last[0] : nil
  end
  def fetch_subtitle_files
    if dir_exist? dir
      Dir.foreach(dir) { |file| @@files_array << file if (supported? file) && (not_empty file) && (writable? file)  }
    elsif files.is_a?(Array) && files.any?
      files.each {|file| @@files_array << file if (supported? file) && (exist? file) && (not_empty file) && (writable? file)  }
    end
  end
  def exist? file_name
    !file_name.nil? && File.exist?(file_name)
  end
  def dir_exist? directory_name
    !directory_name.nil? && Dir.exist?(directory_name)
  end
  def supported? file_name
    true unless (@@supported_formats.match(file_name)).nil?
  end
  def get_file_extension file_name
    File.extname(file_name)
  end
  def not_empty file_name
    !File.zero?(file_name)
  end
  def writable? file_name
    File.writable_real? file_name
  end
end

#subtitle = Subtitler.new(files: ["subtitle/file.txt","subtitle/file1.srt","subtitle/file.srt"] )
#subtitle.show.each { |filename| puts filename }
file =FileValidator.new(file: "subtitle/file.srt")
