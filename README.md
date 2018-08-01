
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kphon

Helper functions for the Kaytetye Phonological Database (kphon).

# Examples

Create standardised export CSV and wav files for kphon.

**Step 0:** Load kphon library and set working directory

``` r
library(kphon)

setwd("~/sandboxes/kphon-v2/annotations/southwind/")
```

**Step 1:** Provide TextGrid file(s) to process, with an Input/Output
mapping

``` r
# Step 1: Provide input TextGrid file(s)
#         and an input-output 'io' mapping for TextGrid tiers to columns
step1 <-
    textgrid_to_kphon(
        input_files = "southwindpassage_AR_MP.TextGrid",
        io_mapping = list(
            orthography   = "word",
            gl_annotated  = "gloss",
            transcription = "phon"
        )
    )
```

**Step 2:** Derive (however appropriate) speaker and annotator columns,
then feed into hash function to derive file name for export

``` r
step2 <-
    step1 %>%
    mutate(
        speaker      = str_extract(string = annotation_source, pattern = "_[A-Z]+_") %>% str_remove_all("_"),
        annotator    = str_extract(string = annotation_source, pattern = "[A-Z]+\\.TextGrid") %>% str_remove("\\.TextGrid"),
        input_wav    = str_replace(string = annotation_source, pattern = "_[A-Z]+.\\TextGrid", ".wav"),
        output_wav   = hash_kphon_wav(orthography, speaker, annotation_source, xmin)
    )
```

**Step 3:** After you’ve verified data extracted correctly in Step 1 and
Step 2, write .wav and .csv files

``` r
write_kphon_exports(kphon_df = step2, path = ".", overwrite = TRUE)
```
