module Marp::Renderer
  class HTMLWithPygments < HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language)
    end

    # def doc_header
    #   <<-EOS
    #   <html>
    #     <head>
    #       <link rel="stylesheet" type="text/css" href="./asset/github.css">
    #     </head>
    #     <body>
    #   EOS
    # end
    # def doc_footer
    #   <<-EOS
    #     </body>
    #   </html>
    #   EOS
    # end
  end
end
