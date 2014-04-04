require 'open-uri'
require 'zlib'

class HtmlPage
  attr_accessor :url, :options

  def initialize(url, options = {})
    self.url = url
    self.options = default_options.merge(options)
  end

  def open_url
    response = open(url, open_uri_options)
    response = Zlib::GzipReader.new(response) if decode_response?(response)
    response
  end

  def html
    Nokogiri::HTML(open_url)
  end

  private

  def gzipped?
    options[:gzip].presence
  end

  def open_uri_options
    @_open_uri_options ||= {}.tap do |opts|
      opts['Accept-Encoding'] = 'gzip, deflate' if gzipped?
    end
  end

  def decode_response?(response)
    gzipped? && response.content_encoding.include?('gzip')
  end

  def default_options
    {
      gzip: true
    }
  end
end
