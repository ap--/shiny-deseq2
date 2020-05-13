# shiny-deseq2 GA helper
# ======================
# Created by: Andreas Poehlmann <andreas@poehlmann.io>

# Come to the Python side.
# I really didn't ask for this. You forced me to do it.
# I know I'm evil. But you made R the way it is.
`_google_analytics_tag_html` <- function(token) {
  shiny::HTML(stringr::str_glue(
    "<!-- Global site tag (gtag.js) - Google Analytics -->
    <script async src=\"https://www.googletagmanager.com/gtag/js?id={token}\"></script>
    <script>
      window.dataLayer = window.dataLayer || [];
      function gtag(){{dataLayer.push(arguments);}}
      gtag('js', new Date());
      gtag('config', '{token}');
    </script>",
    token = token
  ))
}
