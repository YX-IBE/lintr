#' Pipe call linter
#'
#' Force explicit calls in magrittr pipes, e.g.,
#' `1:3 %>% sum()` instead of `1:3 %>% sum`.
#'
#' @evalRd rd_tags("pipe_call_linter")
#' @seealso [linters] for a complete list of linters available in lintr.
#' @export
pipe_call_linter <- function() {
  Linter(function(source_file) {
    if (length(source_file$parsed_content) == 0L) {
      return(list())
    }

    xml <- source_file$xml_parsed_content

    # NB: the text() here shows up as %&gt;% but that's not matched, %>% is
    # NB: use *[1][self::SYMBOL] to ensure the first element is SYMBOL, otherwise
    #       we include expressions like x %>% .$col
    xpath <- "//expr[preceding-sibling::SPECIAL[text() = '%>%'] and *[1][self::SYMBOL]]"
    bad_expr <- xml2::xml_find_all(xml, xpath)

    return(lapply(
      bad_expr,
      xml_nodes_to_lint,
      source_file = source_file,
      lint_message = "Use explicit calls in magrittr pipes, i.e., `a %>% foo` should be `a %>% foo()`.",
      type = "warning"
    ))
  })
}
