#' Create unique hash for kphon wav file
#'
#' @param orthography orthographic represention of Kaytetye form
#' @param speaker initials of speaker in wav file
#' @param annotation_source TextGrid file from which annotation was extracted
#' @param xmin the start time of the annotation in TextGrid file
#'
#' @importFrom purrr pmap_chr
#' @importFrom digest digest
#'
#' @export
#'
#' @examples
#'
#' hash_kphon_wav("aleke", "AR", "southwindpassage_AR_MP.TextGrid", 4.56)
#'

hash_kphon_wav <- function(orthography, speaker, annotation_source, xmin) {

    pmap_chr(.l = list(
        orthography,            # ..1
        speaker,                # ..2
        annotation_source,      # ..3
        round(xmin, digits = 2) # ..4
    ), .f = ~ paste0(..1, "_", ..2, "_", digest(list(..3, ..4), algo = "crc32"), ".wav")
    )

}
