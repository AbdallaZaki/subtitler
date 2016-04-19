class RegexHandler
  def self.valid_block_expression
    regexfiy "(?<block>(?<slide_num>#{Slide_number})\\n#{valid_time_block}(?<text>#{Subtitle_lines})"
  end
  def self.with_out_slider_block_expression
    regexfiy "(?<block>#{valid_time_block}(?<text>#{Subtitle_lines})"
  end
  def self.loosely_block_expression
    regexfiy "(?<block>(?<slide_num>#{Loosely_Slide_number})?\\n#{loosely_time_block}?(?<text>#{Subtitle_lines})"
  end
  def self.empty_lines
    Empty_lines
  end
  def self.empty_line
    Empty_line
  end
  def self.valid_time_expression
    regexfiy valid_time
  end
  def self.valid_time_block_expression
    regexfiy "#{valid_time_block}\\z"
  end
  def self.loosely_time_block_expression
    regexfiy loosely_time_block
  end
  def self.slide_number
    SLide_num_block
  end
  def self.slide_number_in_block
    regexfiy Slide_number 
  end
  private
  Empty_lines=/(\n^\s*$){2,}/
  Empty_line=/(\n^\s*$){1}/
  Slide_number="^[0-9]+$"
  SLide_num_block=/^[0-9]+\s?\z/
  Hours="[0-9]{2}"
  Minutes="[0-5][0-9]"
  Millisec="[0-9]{1,3}"
  Loosely_Slide_number="^([0-9]\\s*)+$"
  Subtitle_lines="((\\n.+$)+))"
  Loosely_hours="[0-9]?\\s*[0-9]?\\s*"
  Loosely_minutes="[0-5]?\\s*[0-9]?\\s*"
  Loosely_millisec="[0-9]?\\s*[0-9]?\\s*[0-9]?"
  def self.regexfiy text
    Regexp.new(text)
  end
  def self.valid_time
    "#{Hours}:#{Minutes}:#{Minutes},#{Millisec}"
  end
  def self.loosely_time
    "#{Loosely_hours}:?\\s*#{Loosely_minutes}:?\\s*#{Loosely_minutes},?\\s*#{Loosely_millisec}"
  end
  def self.loosely_time_block
    "(?<time>(?<start_time>#{loosely_time})(?<arrow>\\s+-\\s*-\\s*>\\s+)?(?<end_time>#{loosely_time}))"
  end
  def self.valid_time_block
    "(?<start_time>#{valid_time})\\s-->\\s(?<end_time>#{valid_time})"
  end
end
