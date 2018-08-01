
make_kphon_csv <- function(input_files, input_format, io_mapping) {

    stopifnot(input_formant %in% c("TextGrid"))
    stopifnot(all(names(io_mappings) %in% c("orthography", "gl_annotated", "transcription")))

    switch(EXPR = input_format,
           TextGrid = textgrid_to_kphon(input_files, io_mapping)
    )
}
