;;; markdown-to-reveal.el --- Markdown to reveal.js converter
;; Copyright (C) 2015,2016 kazuya-gosho
;;; Commentary:
;; See http://lab.hakim.se/reveal-js
;;; Code:

(defvar reveal-header "<!doctype html>
<html lang=\"en\">

  <head>
    <meta charset=\"utf-8\">

    <title>reveal.js – The HTML Presentation Framework</title>

    <meta name=\"description\" content=\"A framework for easily creating beautiful presentations using HTML\">
    <meta name=\"author\" content=\"Hakim El Hattab\">

    <meta name=\"apple-mobile-web-app-capable\" content=\"yes\">
    <meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black-translucent\">

    <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no\">

    <!-- solarized dark theme for reveal.js -->
    <link rel=\"stylesheet\" href=\"http://lab.hakim.se/reveal-js/css/reveal.css\">
    <link rel=\"stylesheet\" href=\"http://lab.hakim.se/reveal-js/css/theme/black.css\" id=\"theme\">
    <link rel=\"stylesheet\" href=\"http://lab.hakim.se/reveal-js/lib/css/zenburn.css\">

  </head>

  <body>
    <div class=\"reveal\">
      <div class=\"slides\">
        <section data-markdown
          data-separator=\"\\n---\\n$\"
          data-separator-vertical=\"\\n--\\n$\">
          <script type=\"text/template\">
")

(defvar reveal-footer "
          </script>
        </section>

        <script src=\"http://lab.hakim.se/reveal-js/lib/js/head.min.js\"></script>
        <script src=\"http://lab.hakim.se/reveal-js/js/reveal.js\"></script>

        <!-- configuration -->
        <script>
          // More info https://github.com/hakimel/reveal.js#configuration
          Reveal.initialize({
          controls: true,
          progress: true,
          history: true,
          center: true,

          transition: 'slide', // none/fade/slide/convex/concave/zoom
          });
        </script>

        <script src=\"http://lab.hakim.se/reveal-js/lib/js/classList.js\"></script>
        <script src=\"http://lab.hakim.se/reveal-js/plugin/markdown/marked.js\"></script>
        <script src=\"http://lab.hakim.se/reveal-js/plugin/markdown/markdown.js\"></script>
        <script src=\"http://lab.hakim.se/reveal-js/plugin/highlight/highlight.js\"></script>
        <script src=\"http://lab.hakim.se/reveal-js/plugin/zoom-js/zoom.js\"></script>

        <script>
          window.addEventListener('DOMContentLoaded', function() {
            hljs.initHighlighting();
          }, true);
        </script>
      </div>
    </div>
  </body>
</html>
")

(defun reveal-paste-to-tmp-file(data)
  (with-temp-buffer
    (insert data)
    (write-file "/tmp/reveal.html")))

(defun markdown-to-reveal()
  (interactive)
  (paste-to-tmp-file  (concat reveal-header (buffer-string) reveal-footer))
  (browse-url-xdg-open "file:///tmp/reveal.html#/1"))

(provide 'markdown-to-reveal)

;;; markdown-to-reveal.el ends here
