# generic response object
class Response
  attr_accessor :content, :error

  def initialize
    @content = nil
    @error = nil
  end

  def success?
    !@error
  end

  def collate_errors(input, message = '')
    if input.error
      @error ||= message.to_s
      @error << input.error
    end
  end
end
