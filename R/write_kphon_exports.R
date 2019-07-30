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

write_kphon_exports <- function (kphon_df, path, overwrite = FALSE, ffmpeg_path = "ffmpeg")
{
    stopifnot(dir.exists(path))
    export_path <- file.path(path, "_kphon-export", fsep = "/")
    if (!dir.exists(export_path)) {
        dir.create(export_path)
    }
    select(kphon_df, orthography, gl_annotated, transcription,
           annotator, kphon_export = output_wav, annotation_source,
           xmin, xmax) %>% write_csv(file.path(export_path, "_kphon-export.csv"))

    kphon_df %>%
        mutate(
            read_path = input_wav,
            output_wav = file.path(export_path, output_wav, fsep = "/")
        ) %>%
        glue_data("{ffmpeg_path} {ifelse(overwrite, '-y', '-n')} -i {read_path} -ss {round(xmin, 3)} -t {round(xmax - xmin, 3)} -ac 1 {output_wav}") %>%
        walk(system)
    # I()
}
