require "marp/version"
require "marp/renderer"
require 'redcarpet'
require 'pygments'
require 'pdfkit'
require 'tempfile'

module Marp
  def self.run(params)
    Exporter.exports(params)
  end

  class Exporter
    def self.exports(params)
      get_files(params).each do |file_path|
        self.new(file_path).export_pdf
      end
    end

    def initialize(file_path)
      @file_path = file_path
    end

    def export_pdf
      markdown = Redcarpet::Markdown.new(
        Marp::Renderer::HTMLWithPygments,
        autolink:            true,
        tables:              true,
        fenced_code_blocks:  true,
        strikethrough:       true,
        space_after_headers: true,
        superscript:         true,
        underline:           true,
        highlight:           true,
        quote:               true,
        footnotes:           true
      )
      file = File.open(@file_path.real_path).read
      html = markdown.render(file)
      File.write(File.expand_path('../../test.html', __FILE__), html)

      dirname = File.dirname(@file_path.export_path)
      unless Dir.exist?(dirname)
        FileUtils.mkdir_p(dirname)
      end

      kit = PDFKit.new(html)
      kit.stylesheets << File.expand_path('../../asset/github.css', __FILE__)
      kit.stylesheets << pygments_css_path
      kit.to_file(@file_path.export_path)
    end

    def pygments_css_path
      css = Tempfile.new('pygments.css')
      css.write(Pygments.css)
      css.close
      css.path
    end

    def self.get_files(params)
      params.inject([]) do |ary, path|
        next ary unless File.exist?(path)
        if File.directory?(path)
          Dir.glob(File.expand_path('**/*', path)).inject(ary) do |a, real_path|
            a << FilePath.new(path, real_path)
          end
        else
          ary << FilePath.new(path, File.expand_path(path))
        end
      end.uniq(&:real_path).select do |file_path|
        file_path.real_path =~ /\.md\z/
      end
    end
  end

  class FilePath
    attr_reader :real_path, :export_path

    def initialize(input_path, real_path)
      @real_path  = real_path
      @export_path = if File.expand_path(input_path) == real_path
                       File.expand_path(
                         "./export/#{
                           File.basename(real_path).gsub(/\.md\z/, '')
                         }.pdf",
                         Dir.pwd
                       )
                     else
                       File.expand_path(
                         "./export/#{
                           real_path
                           .sub(File.expand_path(input_path), '')
                           .gsub(/\A\//, '')
                           .gsub(/\.md\z/, '')
                         }.pdf",
                         Dir.pwd
                       )
                     end
    end
  end
end
