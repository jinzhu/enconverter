require 'iconv'

module Rack
  class Enconverter
    def initialize(app, options={})
      @app, @convert = app, options[:convert]
    end

    def convert?(env)
      @convert.is_a?(Proc) && @convert.call(env)
    end

    def call(env)
      convert = convert?(env)
      scrub(env) if convert

      status, header, response = @app.call(env)

      if convert && [nil, "text/html", "application/xhtml+xml"].include?(header[:content_type]) && response.respond_to?(:body)
        type, charset = header['Content-Type'].split(/;\s*charset=/)
        response.body = process_body(response.body)
        header['Content-Type'] = "#{type}; charset=shift_jis"
      end

      [status, header, response]
    end

    private
    def process_body(body)
      body_doc = Nokogiri::HTML(body)
      body_doc.meta_encoding = 'shift_jis'
      body_doc.search('meta[@http-equiv="Content-Type"]').map do |e|
        e["content"] = e["content"].sub(/utf-?8/,'shift_jis')
      end

      body = body_doc.to_html
      Iconv.conv('shift_jis//IGNORE','utf-8', body).sub(/charset=utf-?8/,'charset=shift_jis')
    end

    def scrub(env)
      env["rack.request.query_hash"] = scrub_hash(env["rack.request.query_hash"])
      env["rack.request.form_hash"]  = scrub_hash(env["rack.request.form_hash"])
    end

    def scrub_hash(hash)
      return hash unless hash.is_a? Hash

      new_hash = {}
      hash.map do |key, value|
        if value.is_a? String
          new_hash.update({convert_japanese(key) => convert_japanese(value)})
        elsif value.is_a? Hash
          new_hash.update({convert_japanese(key) => scrub_hash(value)})
        end
      end
      new_hash
    end

    def convert_japanese(str)
      # Iconv.conv('utf-8//IGNORE','shift_jis', str)
      str
    end
  end
end
