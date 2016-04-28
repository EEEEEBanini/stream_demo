class BrowseController < ApplicationController
  include ActionController::Live

  BUFFER_SIZE = 1024 * 1024

  def download
    conn = Faraday.new(:url => "http://file_server:8889")
    Rails.logger.debug "URL IS::: #{ENV['FILE_SERVER_URL']}"
    file_size = conn.get('/size').body.to_i || 0
    response.content_type = 'application/octet-stream'
    begin
      if (file_size < BUFFER_SIZE)
        response.stream.write(conn.get('/').body)
      else
        offset = 0
        while offset < file_size do
          response.stream.write(conn.get('/', {:start => offset, :limit => BUFFER_SIZE}).body)
          offset += BUFFER_SIZE
        end
      end
    rescue Exception => e
      Rails.logger.warn "Error while streaming: #{e.class}: #{e.message}"
    ensure
      response.stream.close
    end
  end


  def index
    @path = HdfsPath.parse params['path']

    hdfs_item = get_hdfs_status @path
    case hdfs_item
    when HdfsFile
      response.content_type = 'application/octet-stream'
      begin
        if (hdfs_item.length < BUFFER_SIZE)
          response.stream.write(client.read(@path.to_s))
        else
          offset = 0
          while offset < hdfs_item.length do
            response.stream.write(client.read(@path.to_s, offset: offset, length: BUFFER_SIZE))
            offset += BUFFER_SIZE
          end
        end
      rescue Exception => e
        Rails.logger.warn "Error while streaming: #{e.class}: #{e.message}"
      ensure
        response.stream.close
      end
    when HdfsDirectory
      @directory_list = get_hdfs_list_status(@path)
    end
  end

  private

  def client
    config = Rails.application.config_for(:webhdfs).with_indifferent_access
    WebHDFS::Client.new(config[:host], config[:port], config[:username])
  end

  def get_hdfs_status(path)
    status = client.stat(path.to_s)
    case status['type']
    when 'FILE'
      HdfsFile.new(path, status['length'])
    when 'DIRECTORY'
      HdfsDirectory.new(path)
    end
  end

  def get_hdfs_list_status(path)
    statuses = client.list(path.to_s)
    result = []
    statuses.each do |status|
      case status['type']
      when 'FILE'
        result << HdfsFile.new(path.join(status['pathSuffix']), status['length'])
      when 'DIRECTORY'
        result << HdfsDirectory.new(path.join(status['pathSuffix']))
      end
    end
    result
  end
end
