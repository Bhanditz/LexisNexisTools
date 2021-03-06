## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library("kableExtra")

## ---- message=FALSE------------------------------------------------------
library("LexisNexisTools")

## ---- eval=FALSE---------------------------------------------------------
#  # For example
#  setwd("C:/Test/LNTools_test")
#  
#  # Or
#  setwd("~/Test/LNTools_test")

## ---- eval=FALSE---------------------------------------------------------
#  lnt_sample()

## ---- eval=FALSE---------------------------------------------------------
#  report.df <- lnt_rename()

## ---- eval=FALSE---------------------------------------------------------
#  report.df <- lnt_rename(x = getwd(), report = TRUE)

## ---- eval=FALSE---------------------------------------------------------
#  my_files <- list.files(pattern = ".txt", path = getwd(),
#                         full.names = TRUE, recursive = TRUE, ignore.case = TRUE)
#  report.df <- lnt_rename(x = my_files, report = TRUE)
#  
#  report.df

## ---- echo=FALSE---------------------------------------------------------
library(kableExtra)
unlink("SampleFile_20091201-20100511_1-10.txt")
report.df <- lnt_rename(x = lnt_sample(overwrite = TRUE), simulate = FALSE, report = TRUE, verbose = FALSE)
report.df$name_orig <- basename(report.df$name_orig)
report.df$name_new <- basename(report.df$name_new)
kable(report.df, format = "markdown")

## ------------------------------------------------------------------------
LNToutput <- lnt_read(x = getwd())

## ---- eval=FALSE---------------------------------------------------------
#  meta.df <- LNToutput@meta
#  articles.df <- LNToutput@articles
#  paragraphs.df <- LNToutput@paragraphs
#  
#  # Print meta to get an idea of the data
#  head(meta.df, n = 3)
#  

## ---- echo=FALSE---------------------------------------------------------
meta.df <- LNToutput@meta
articles.df <- LNToutput@articles
paragraphs.df <- LNToutput@paragraphs

meta.df$Source_File <- basename(meta.df$Source_File)
# Print meta to get an idea of the data
kable(head(meta.df, n = 3), format = "markdown")


## ---- message=FALSE------------------------------------------------------
library("dplyr")
meta_articles.df <- meta.df %>%
  right_join(articles.df, by = "ID")

# Or keep the paragraphs
meta_paragraphs.df <- meta.df %>%
  right_join(paragraphs.df, by = c("ID" = "Art_ID"))

## ------------------------------------------------------------------------
quanteda_corpus <- lnt_convert(LNToutput, to = "rDNA")

corpus <- lnt_convert(LNToutput, to = "quanteda")

tCorpus <- lnt_convert(LNToutput, to = "corpustools")

tidy <- lnt_convert(LNToutput, to = "tidytext")

Corpus <- lnt_convert(LNToutput, to = "tm")

dbloc <- lnt_convert(LNToutput, to = "lnt2SQLite")

## ---- eval=FALSE---------------------------------------------------------
#  # Either provide a LNToutput
#  duplicates.df <- lnt_similarity(LNToutput = LNToutput,
#                                  threshold = 0.97)

## ---- results='hide'-----------------------------------------------------
# Or the important parts separatley
duplicates.df <- lnt_similarity(texts = LNToutput@articles$Article,
                                dates = LNToutput@meta$Date,
                                IDs = LNToutput@articles$ID,
                                threshold = 0.97)


## ---- eval=FALSE---------------------------------------------------------
#  lnt_diff(duplicates.df, min = 0, max = Inf)

## ------------------------------------------------------------------------
duplicates.df <- duplicates.df[duplicates.df$rel_dist < 0.2]
LNToutput <- LNToutput[!LNToutput@meta$ID %in% duplicates.df$ID_duplicate, ]

## ------------------------------------------------------------------------
LNToutput[1, ]

## ---- eval=FALSE---------------------------------------------------------
#  #' generate new dataframes without highly similar duplicates
#  meta.df <- LNToutput@meta
#  articles.df <- LNToutput@articles
#  paragraphs.df <- LNToutput@paragraphs
#  
#  # Print e.g., meta to see how the data changed
#  head(meta.df, n = 3)

## ---- echo=FALSE---------------------------------------------------------
meta.df <- LNToutput@meta
articles.df <- LNToutput@articles
paragraphs.df <- LNToutput@paragraphs

kable(head(meta.df, n = 3), format = "markdown")

## ------------------------------------------------------------------------
lnt_lookup(LNToutput, pattern = "statistical computing")

## ------------------------------------------------------------------------
LNToutput@meta$stats <- lnt_lookup(LNToutput, pattern = "statistical computing")
LNToutput <- LNToutput[!sapply(LNToutput@meta$stats, is.null), ]
LNToutput

## ------------------------------------------------------------------------
lnt_lookup(LNToutput, pattern = "stat.*?")

## ------------------------------------------------------------------------
table(unlist(lnt_lookup(LNToutput, pattern = "stat.+?\\b")))

