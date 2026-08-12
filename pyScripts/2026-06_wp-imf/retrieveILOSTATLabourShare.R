#!/usr/bin/env Rscript

# Retrieve the official ILOSTAT SDG 10.4.1 annual labour-income-share series.

args <- commandArgs(trailingOnly = FALSE)
file_arg <- sub("^--file=", "", args[grep("^--file=", args)])
script_dir <- dirname(normalizePath(file_arg))
project_root <- normalizePath(file.path(script_dir, "..", ".."))
data_dir <- file.path(project_root, "data")

dataset_id <- "SDG_1041_NOC_RT_A"
url <- paste0(
  "https://rplumber.ilo.org/files/indicator/",
  dataset_id,
  ".rds"
)
raw_path <- file.path(data_dir, paste0(dataset_id, ".rds"))
csv_path <- file.path(data_dir, paste0(dataset_id, ".csv"))

dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)
download.file(
  url,
  raw_path,
  mode = "wb",
  quiet = FALSE,
  headers = c(`User-Agent` = "Rilostat/2.3.4 (macOS)")
)

data <- readRDS(raw_path)
required <- c(
  "ref_area", "source", "indicator", "time", "obs_value",
  "obs_status", "best_source"
)
stopifnot(all(required %in% names(data)))

write.csv(as.data.frame(data), csv_path, row.names = FALSE, na = "")
message("Saved ", nrow(data), " observations to:")
message("  ", raw_path)
message("  ", csv_path)
