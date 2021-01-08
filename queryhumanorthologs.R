###### -- Perform RBH for a given genome against human ------------------------
# author: Nicholas Cooley
# contact: npc19@pitt.edu / npcooley@gmail.com

# requirements:
# Biostrings
# BLAST

# Basic format:
# Script will pull the proteome for the human genome and take in the proteome of a user's
# choice and perform reciprocal best hits between the two. This is the barest bones, but also
# the most flexible way to predict orthology. BLAST will be run with standard arguments with the exception of:
# if R can detect multiple cores, it will try to and blastp against the max number of cores possible
# and smith waterman trackback is enabled
# evalue cutoff is set to 1e-6

# usage:
# Rscript queryhumanorthologs.R <target proteome> <output filename>

# output:
# returns a reciprocal best hits table
# selected based on PID

# note: 
# BLAST PIDs are local PIDs
# there will be best hits with poor PIDs, it is up to user discretion to determine
# what PID threshold they will want to apply
# 60 ~ a normative community agree'd upon threshold
# 40 ~ incredibly liberal
# 80 ~ conservative and probably the most specific

# Other hardcoded things:
Eval <- 1e-6

# Subject Seqs: AAs from current human genome assembly

# For Testing:
# ReferenceSeqs <- "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/698/785/GCF_000698785.1_ASM69878v1/GCF_000698785.1_ASM69878v1_protein.faa.gz"
# testing partner:
# https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/013/407/185/GCF_013407185.1_ASM1340718v1/GCF_013407185.1_ASM1340718v1_protein.faa.gz
# For Running:
ReferenceSeqs <- "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.39_GRCh38.p13/GCF_000001405.39_GRCh38.p13_protein.faa.gz"

if ("BiocManager" %in% rownames(installed.packages())) {
  if ("Biostrings" %in% rownames(installed.packages())) {
    suppressMessages(library(Biostrings))
  } else {
    stop (paste0("Biostrings appears to not be installed, please visit: https://www.bioconductor.org/"))
  }
} else {
  stop (paste0("BiocManager appears to not be installed, please visit: https://www.bioconductor.org/"))
}

if ("parallel" %in% rownames(installed.packages())) {
  cat("\nR is using the 'parallel' package to detect cores for multithreading.\n\n")
  NumCores <- parallel::detectCores()
} else {
  cat("\nBLAST will be run using a single thread.\n\n")
  NumCores <- 1L
}

AvailablePath <- Sys.getenv("PATH")

BLASTPresent <- grepl(pattern = "blast",
                      x = Sys.getenv("PATH"))
if (!BLASTPresent) {
  stop ("BLAST does not appear in the available PATH, please visit: https://www.ncbi.nlm.nih.gov/books/NBK279671/")
}

# take in a single argume

Args <- commandArgs(trailingOnly = TRUE)

if (length(Args) > 2L) {
  stop ("Only 2 arguments are currently accepted.")
}
if (length(Args) == 1L) {
  stop ("An argument is missing.")
}

suppressMessages(library(Biostrings))

Seqs01 <- readAAStringSet(ReferenceSeqs)
Seqs02 <- readAAStringSet(Args[1L])

# take only the accession from the header names

n01 <- names(Seqs01)
n01 <- strsplit(n01,
                split = " ",
                fixed = TRUE)
n01 <- unname(sapply(n01,
                     function(x) x[1],
                     simplify = TRUE,
                     USE.NAMES = FALSE))
n02 <- names(Seqs02)
n02 <- strsplit(n02,
                split = " ",
                fixed = TRUE)
n02 <- unname(sapply(n02,
                     function(x) x[1],
                     USE.NAMES = FALSE,
                     simplify = TRUE))
names(Seqs01) <- n01
names(Seqs02) <- n02

FunStart <- Sys.time()

# create the tempfile for Seqs01
TEMPSEQS01 <- tempfile()
writeXStringSet(x = Seqs01,
                filepath = TEMPSEQS01,
                append = FALSE)
# create the tempdir for Seqs01
Dir01 <- paste0(tempdir(),
                "/TempSeqs01")
dir.create(path = Dir01)
# create the tempfile for the forward table
TEMPTABLE01 <- tempfile()
# create the tempfile for Seqs02
TEMPSEQS02 <- tempfile()
writeXStringSet(x = Seqs02,
                filepath = TEMPSEQS02,
                append = FALSE)
# create the tempdir for Seqs02
Dir02 <- paste0(tempdir(),
                "/TempSeqs02")
# create the tempfile for the reverse table
TEMPTABLE02 <- tempfile()

system(command = paste("makeblastdb -in ",
                       TEMPSEQS02,
                       " -dbtype prot ",
                       "-out ",
                       paste0(Dir02,
                              "/DB"),
                       sep = ""))
system(command = paste("blastp -query ",
                       TEMPSEQS01,
                       " -outfmt 6 -evalue ",
                       Eval,
                       " -use_sw_tback -db ",
                       paste0(Dir02,
                              "/DB"),
                       " -num_threads ",
                       NumCores,
                       " -out ",
                       TEMPTABLE01,
                       sep = ""))

cat("BLAST one completed.")

# build a DB out of seqs01
# BLAST reverse
system(command = paste("makeblastdb -in ",
                       TEMPSEQS01,
                       " -dbtype prot ",
                       "-out ",
                       paste0(Dir01,
                              "/DB"),
                       sep = ""))
system(command = paste("blastp -query ",
                       TEMPSEQS02,
                       " -outfmt 6 -evalue ",
                       Eval,
                       " -use_sw_tback -db ",
                       paste0(Dir01,
                              "/DB"),
                       " -num_threads ",
                       NumCores,
                       " -out ",
                       TEMPTABLE02,
                       sep = ""))

cat("BLAST two completed.\n")

ForwardResult <- read.table(file = TEMPTABLE01,
                            sep = "\t",
                            header = FALSE)
ReverseResult <- read.table(file = TEMPTABLE02,
                            sep = "\t",
                            header = FALSE)

# find best match from forward result
# and from reverse result
# combine

u1 <- unique(ForwardResult[, 1L])
CondensedForward <- vector(mode = "list",
                           length = length(u1))
for (m1 in seq_along(u1)) {
  currentresult <- ForwardResult[ForwardResult[, 1L] == u1[m1], ]
  CondensedForward[[m1]] <- currentresult[which.max(currentresult[, 3L]), ]
}
CondensedForward <- do.call(rbind,
                            CondensedForward)

u2 <- unique(ReverseResult[, 1L])
CondensedReverse <- vector(mode = "list",
                           length = length(u2))
for (m1 in seq_along(u2)) {
  currentresult <- ReverseResult[ReverseResult[, 1L] == u2[m1], ]
  CondensedReverse[[m1]] <- currentresult[which.max(currentresult[, 3L]), ]
}
CondensedReverse <- do.call(rbind,
                            CondensedReverse)

# combine results
l1 <- paste(CondensedForward[, 1L],
            CondensedForward[, 2L])
l2 <- paste(CondensedReverse[, 2L],
            CondensedReverse[, 1L])

if (length(l1) >= length(l2)) {
  l3 <- match(x = l2,
              table = l1)
  p1 <- CondensedForward[l3[!is.na(l3)], ]
  p2 <- CondensedReverse[!is.na(l3), ]
} else {
  l3 <- match(x = l1,
              table = l2)
  p1 <- CondensedForward[!is.na(l3), ]
  p2 <- CondensedReverse[l3[!is.na(l3)], ]
}

# remove tempfiles

system(command = paste0("rm ",
                        TEMPSEQS01,
                        " ",
                        TEMPSEQS02,
                        " ",
                        TEMPTABLE01,
                        " ",
                        TEMPTABLE02))
system(command = paste0("rm -r ",
                        Dir01))
system(command = paste0("rm -r ",
                        Dir02))

result <- data.frame("GRCh38_p13_id" = p1[, 1L],
                     "subject_id" = p1[, 2L],
                     "fpid" = p1[, 3L],
                     "feval" = p1[, 11L],
                     "fbit" = p1[, 12L],
                     "rpid" = p2[, 3L],
                     "reval" = p2[, 11L],
                     "rbit" = p2[, 12L],
                     stringsAsFactors = FALSE)

write.table(x = result,
            file = Args[2L],
            append = FALSE,
            row.names = FALSE,
            col.names = TRUE,
            quote = FALSE,
            sep = " ")

FunEnd <- Sys.time()

print(FunEnd - FunStart)


