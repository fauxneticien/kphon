#' Sync master audio directory with audio from all _kphon-export folders
#'
#' @param kphon_path path to kphon directory where audio and annotations directories exist
#' @param show_summary return summary (default is \code{TRUE}). Must explicitly supply \code{FALSE} to begin moving new files and deleting stale files.
#'
#' @export
#'

sync_kphon_audio <- function(kphon_path, show_summary = TRUE) {

    kphon_master <- file.path(kphon_path, "data", "kphon-master", "_kphon-master.csv")
    annots_dir   <- file.path(kphon_path, "annotations")
    audio_dir    <- file.path(kphon_path, "audio")

    stopifnot(file.exists(kphon_master))
    stopifnot(dir.exists(annots_dir))
    stopifnot(dir.exists(audio_dir))

    kphon_files <- list.files(audio_dir)

    summary_df <-
        suppressMessages(read_csv(kphon_master)) %>%
            filter(!is.na(kphon_export)) %>%
            select(project, kphon_export) %>%
            mutate(
                import_path   = file.path(kphon_path, "annotations", project, "_kphon-export", kphon_export),
                import_exists = file.exists(import_path),
                in_audio_dir  = kphon_export %in% kphon_files
            )

    if(show_summary) {

        summary_df

    } else {

        message("Importing new files...")

        summary_df %>%
            filter(import_exists, !in_audio_dir) %>%
            .$import_path %>%
            file.copy(from = ., to = audio_dir)

        message("Deleting stale files...")

        kphon_files %>%
            discard(~ . %in% summary_df$kphon_export) %>%
            file.path(kphon_path, "audio", .) %>%
            file.remove()

    }

}
