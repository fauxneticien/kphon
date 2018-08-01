#' Convert data from TextGrid file(s) to the kphon data frame specification
#'
#' @param input_files a vector of TextGrid files
#' @param io_mapping a list specifying input/output mapping configuration (see main README for specification)
#'
#' @importFrom purrr imap map_df
#'
#' @export
#'

textgrid_to_kphon <- function(input_files, io_mapping) {

    stopifnot(all(tools::file_ext(input_files) == "TextGrid"))
    stopifnot(all(file.exists(input_files)))
    stopifnot(all(names(io_mapping) %in% c("orthography", "gl_annotated", "transcription")))

    map_df(.x = input_files, .f = function(textgrid_path) {

        tg_data <- readTextGrid(textgrid_path)

        imap(.x = io_mapping, .f = function(tier_name, kphon_col) {

            tg_data %>%
            getTierByName(tier_name = tier_name) %>%
            getTierIntervals(discard_empty = TRUE) %>%
            rename(!!quo_name(kphon_col) := text)
        }) %>%

        reduce(left_join) %>%

        cbind(annotation_source = textgrid_path, stringsAsFactors = FALSE)

    })

}
