class HdfsFile
  attr_reader :path
  attr_reader :length

  def initialize(path, length)
    @path = path
    @length = length
  end

  def to_file_size
    size = @length
    return "#{size} bytes" if size <= 1024
    size = size / 1024
    return "#{size} kb" if size <= 1024
    size = size / 1024
    return "#{size} mb" if size <= 1024
    size = size / 1024
    "#{size} gb"
  end
end
