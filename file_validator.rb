require_relative 'regex_handler.rb'
require_relative 'block_types.rb'
class FileValidator
  @@optimized_text=""
  @@subtitle_file_text=""
  @@subtitle_blocks=[]
  attr_accessor :file
  def initialize args
    @file=args[:file]
    fatch_file_text
    is_vaild?
  end
  include BlockTypes
  def is_vaild?
    @@subtitle_blocks=get_subtitle_blocks
    prev_time = nil
    @@subtitle_blocks.each_with_index do |block , index|
       block_fixar block , index , prev_time
    end
    puts @@optimized_text
  end
  private

  def block_fixar block , index , pre_time
    if valid_block? block
      add_valid_block block
    elsif with_out_slider_block? block
      add_valid_block "#{find_slide_number}\n#{block}"
    elsif slide_number? block
      find_block_for_slider block
    elsif valid_time_block? block
      Vaild_time_block
    elsif loosely_block? block
      Broken_block
    else
      Unidentified
    end
  end

  def remove_extra_empty_lines text
    text.gsub!(RegexHandler.empty_lines,"\n")
  end
  def get_subtitle_blocks
    text=remove_extra_empty_lines @@subtitle_file_text
    empty_line=RegexHandler.empty_line
    text.nil? ? text=@@subtitle_file_text.split(empty_line) : text=text.split(empty_line)
    text.select{|x| (x !="\n")&&(x !="")}
  end
  def fatch_file_text
    if !file.nil?
      @@subtitle_file_text=File.read(file)
    end
  end
  def matched? text , pattren
    if !text.nil? && !pattren.nil?
      !(text.match(pattren)).nil?
    end
  end
  def any_unidentified_text? text , pattren
    if !text.nil? && !pattren.nil?
      text.gsub!(pattren,"")
    end
  end
  def add_valid_block block
    @@optimized_text += "#{block}\n"
  end
  def find_slide_number
    last_vsn = @@optimized_text.scan(RegexHandler.slide_number_in_block).last
    last_vsn.nil? ? 1 : last_vsn.to_i + 1
  end
  def find_block_for_slider number
    vaild_number = find_slide_number
    if vaild_number == number
      
    end
  end
  def valid_block? block
    matched? block , RegexHandler.valid_block_expression
  end
  def with_out_slider_block? block
    matched? block , RegexHandler.with_out_slider_block_expression
  end
  def slide_number? block
    matched? block , RegexHandler.slide_number
  end
  def valid_time_block? block
    matched? block , RegexHandler.valid_time_block_expression
  end
  def loosely_block? block
    matched? block ,RegexHandler.loosely_block_expression
  end
end
