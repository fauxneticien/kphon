#' Make kphon master file
#'
#' @param kphon_path local path to kphon directory in which 'annotations' directory exists
#' @param output_csv (over)write to _kphon-master.csv file? Default is false.
#'
#' @export
#'

make_kphon_master <- function(kphon_path = ".", output_csv = FALSE) {

    if(!dir.exists("annotations")) { stop("Cannot find 'annotations' folder in current path.") }

    kphon_csvs <- list.files(
        path = "annotations",
        pattern = "_kphon-export.csv",
        recursive = TRUE,
        full.names = TRUE
    )

    if(identical(kphon_csvs, character(0))) { stop("Cannot find any '_kphon-export.csv' files within 'annotations' directory.") }

    kdb_csv <- list.files(system.file("extdata", package = "kphon"), pattern = "KDB.*?\\.csv", full.names = TRUE) %>%
        read_csv(col_types = "ccnccc") %>%
        filter(
            !str_detect(orthography, "^[-|+]"),
            !str_detect(orthography, "[-|+]$")
        )

    master_df <-
        kphon_csvs %>%
        map(function(csv_path) {
            message(paste0("Reading ", csv_path, sep = ""))

            suppressMessages(read_csv(csv_path)) %>%
                mutate(project = str_extract(csv_path, "([^\\\\|/]+)(?=[/|\\\\]_kphon-export)")) %>%
                left_join(kdb_csv)

        }) %>%
        bind_rows()

    master_df <-
        bind_rows(
            master_df,
            filter(kdb_csv, !orthography %in% master_df$orthography)
        ) %>%
        arrange(orthography)

    script_path <- system.file("extdata/orth_to_ipa.pl", package = "kphon")

    input_path  <- tempfile(fileext = "txt")
    writeLines(master_df$orthography, input_path)

    output_path <- tempfile(fileext = "txt")

    message("Generating predicted underlying and surface forms from orthography...")
    system(glue("perl {script_path} {input_path} {output_path}"))
    predicted_df <- read_tsv(output_path, col_names = FALSE, col_types = "ccc")

    master_df$pred_phon <- predicted_df$X2
    master_df$pred_surf <- predicted_df$X3

    master_df <-
        master_df %>%
        select(orthography, lx_entries, gl_1, gl_annotated, sn_max, ps_1, de_1_50,
               pred_phon, pred_surf, transcription, annotator, kphon_export, project,
               annotation_source, xmin, xmax
        )

    if(output_csv) {

        write_csv(master_df, file.path(kphon_path, "data", "kphon-master", "_kphon-master.csv"), na = "")

    } else {

        master_df

    }

}
