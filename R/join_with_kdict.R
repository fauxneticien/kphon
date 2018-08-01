#' Left-join data frame with Kaytetye dictionary database, based on column 'orthography' (default)
#'
#' @param df a data frame
#' @param by common column between \code{df} and KDB data frame
#'
#' @importFrom readr read_csv
#' @importFrom dplyr left_join
#'
#' @export
#'

join_with_kdict <- function(df, by = "orthography") {

    kdb_csv <- list.files(system.file("extdata", package = "kphon"), pattern = "KDB.*?\\.csv", full.names = TRUE) %>%
        read_csv(col_types = "cccccc")

    left_join(df, kdb_csv, by = by)
}
