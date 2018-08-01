#' Test that latin/scientific name(s) lines are well-formed
#'
#' @param kphon_df a kphon data frame, e.g. created using \code{textgrid_to_kphon}
#' @param path directory in which output files will be written
#' @param overwrite should existing wav files be overwritten (default is FALSE)
#' @param ffmpeg_path path to executable ffmpeg binary
#'
#' @export
#'
#' @importFrom readr write_csv
#' @importFrom glue glue glue_data
#'
#' @export
#'

write_kphon_exports <- function(kphon_df, path, overwrite = FALSE, ffmpeg_path = "ffmpeg") {

    stopifnot(dir.exists(path))

    # Write csv file first
    select(kphon_df, orthography, gl_annotated, transcription, annotator, kphon_export = output_wav, annotation_source, xmin, xmax) %>%
    write_csv(file.path(path, "_kphon-export", "_kphon-export.csv"))

    # Make ffmpeg commands
    glue_data(kphon_df, "{ffmpeg_path} {ifelse(overwrite, '-y', '-n')} -i '{normalizePath(input_wav)}' -ss {round(xmin, 3)} -t {round(xmax - xmin, 3)} -ac 1 '{file.path(normalizePath(path), '_kphon-export', output_wav)}'") %>%
    walk(system)

}