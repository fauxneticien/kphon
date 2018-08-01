#' Convert the Kaytetye dictionary database text file into a data frame for use within kphon
#'
#' @param kdb_txt path to KDB.txt file
#'
#' @import dplyr
#' @importFrom readr read_lines
#' @importFrom tidyr extract nest spread
#' @importFrom zoo na.locf
#' @importFrom stringr str_remove
#' @importFrom purrr map_chr
#'
#' @export
#'

kdb_to_kphon <- function(kdb_txt) {

    read_lines(kdb_txt) %>%
    tibble(data = .) %>%
    extract(col   = data,
            regex = "\\\\([a-z]+)\\s(.*)",
            into  = c("code", "value")) %>%

    filter(code %in% c("lx", "se", "sn", "ps", "de", "gl")) %>%

    mutate(lx_group = ifelse(code == "lx", value, NA) %>% na.locf(na.rm = FALSE)) %>%
    group_by(lx_group) %>%
    mutate(se_group = ifelse(code == "se", "se", NA) %>% na.locf(na.rm = FALSE)) %>%
    filter(is.na(se_group)) %>%
    select(-se_group) %>%
    ungroup %>%

    mutate(lx_group = str_remove(lx_group, "\\s+\\|\\d$") %>% str_to_lower()) %>%
    group_by(lx_group, code) %>%
    nest() %>%
    mutate(data = case_when(
        code %in% c("sn")             ~ map_chr(data, ~ length(.$value)),
        code %in% c("ps", "de", "gl") ~ map_chr(data, ~ head(.$value, n = 1)),
        code == "lx"                  ~ map_chr(data, ~ paste0(.$value, collapse = ", "))
    )) %>%
    spread(key = code, value = data) %>%
    mutate(de = ifelse(nchar(de) < 50, de, paste0(substr(de, 0, 50), "..."))) %>%
    select(lx_group, lx_entries = lx, sn_max = sn, ps_1 = ps, gl_1 = gl, de_1 = de)

}
