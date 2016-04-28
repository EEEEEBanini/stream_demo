class HdfsPath
  def self.parse(path)
    return HdfsPath.new unless path

    parts = path.split('/')
    HdfsPath.new parts
  end

  def initialize(parts = [])
    @parts = parts
  end

  def join(part)
    HdfsPath.new(@parts + [part])
  end

  def name
    "" if @parts.empty?
    @parts.last
  end

  def to_directory_s
    "#{@parts.join('/')}/"
  end

  def to_file_s
    "#{@parts.join('/')}"
  end

  def to_s
    to_file_s
  end
end
