
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kphon

Helper functions for the Kaytetye Phonological Database
(kphon).

# Installation

``` r
# If you don't have the devtools package, then do 'install.packages("devtools")' first
devtools::install_github("fauxneticien/kphon")
```

# Examples

Create standardised export CSV and wav files for kphon, which are of the
form:

| orthography    | gl\_annotated  | transcription   | annotator | kphon\_export                    | annotation\_source                |     xmin |     xmax |
| :------------- | :------------- | :-------------- | :-------- | :------------------------------- | :-------------------------------- | -------: | -------: |
| atnyemilparele | south.wind-ERG | ɐcɲejmejlpɐɻələ | MP        | atnyemilparele\_AR\_cf125a3a.wav | southwindpassage\_AR\_MP.TextGrid | 2.125691 | 3.140994 |
| kape           | and            | kɐpə            | MP        | kape\_AR\_29cf0b23.wav           | southwindpassage\_AR\_MP.TextGrid | 3.223741 | 3.606705 |
| aherrkele      | sun-ERG        | ɐːɾkələ         | MP        | aherrkele\_AR\_4bcff7be.wav      | southwindpassage\_AR\_MP.TextGrid | 3.606705 | 4.075386 |
| tyampe         | too            | cɐmpə           | MP        | tyampe\_AR\_95ac9af5.wav         | southwindpassage\_AR\_MP.TextGrid | 4.075386 | 4.511355 |
| ahenge         | fight          | ɐːŋə            | MP        | ahenge\_AR\_e67432f2.wav         | southwindpassage\_AR\_MP.TextGrid | 4.660752 | 4.950565 |

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
