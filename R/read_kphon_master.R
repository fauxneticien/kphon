#' Read kphon master file
#'
#' @param kphon_path local path to kphon directory in which 'annotations' directory exists. Default is "."
#'
#' @export
#'

read_kphon_master <- function(kphon_path = ".") {

    master_path <- file.path(kphon_path, "data", "kphon-master", "_kphon-master.csv", fsep = "/")

    if(!file.exists(master_path)) {
        stop(paste0("Cannot find file: ", master_path))
    }

    read_csv(master_path)

}
