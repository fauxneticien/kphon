#' Copy exported kphon audio to an external directory
#'
#' @param kphon_df subsetted kphon data frame with \code{kphon_export} column
#' @param kphon_path local path to kphon directory in which 'audio' directory exists
#' @param dest_path path to external directory
#' @param overwrite overwrite existing files in \code{dest_path}. Default is \code{TRUE}.
#'
#' @export
#'

copy_kphon_audio <- function(kphon_df, kphon_path, dest_path, overwrite = TRUE) {

    kphon_df %>%
        filter(!is.na(kphon_export)) %>%
        .$kphon_export %>%
        file.path(kphon_path, "audio", .) %>%
        file.copy(
            from = .,
            to   = file.path(dest_path),
            overwrite = overwrite
        ) %>%
        I()

}
