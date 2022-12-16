

#######a little function to check whether landmarks have been placed correctly. When running this, a series of rgl windows will open, each with a plotRefToTarget with the specimen of number i and the comparison specimen. 

# NOTE that setting the window size with par3d(windowRect) needs adjusting to your screen. I set it to my requirements here but it can be hashed out to go to the default size

#First_spec_to_view is first specimen to be compared to comparison spec, 

#Last_spec_to_view is last specimen to be compared to comparison spec,

#Number_of_comparison_spec is the specimen all the other specimens are to be compared to, obviously this needs to be 100% correct. It can be a specimen of a particular number or the number of the specimen closest to teh mean 

Landm.place.check <-
  function (First_spec_to_view,
            Last_spec_to_view,
            Number_of_comparison_spec) {
    for (i in c(First_spec_to_view:Last_spec_to_view)) {
      
      #open 3d windows, set some bits
      open3d()
      par3d(windowRect = c(0, 0, 1000, 1000))
      bg3d("white")
      
      plotRefToTarget(
        GPA_AllSpecimens$coords[, , i],
        GPA_AllSpecimens$coords[, ,Number_of_comparison_spec ],
        label = TRUE,
        method = "vector",
        main = dimnames(GPA_AllSpecimens$coords)[[3]][i],
        gridPars = gridPar(
          pt.size = 0.5,
          pt.bg = "hotpink",
          txt.cex = "1.5"
        )
      )
      
    }
  }




#######This code is from teh supp. materials 8 of Ascarrunz, E., Claude, J., & Joyce, W. G. (2019). Estimating the phylogeny of geoemydid turtles (Cryptodira) from landmark data: an assessment of different methods. PeerJ, 7, e7476. https://doi.org/10.7717/peerj.7476

# Write 2D or 3D landmark data to a file in TNT format. `A` can be either an
# array with landmarks from a single configuration or a list of arrays of
# different configurations. Some species may not be included in all the arrays.
# If that happens, `allow_missing = FALSE` will drop those species from the
# entire dataset. `allow_missing = TRUE` will keep all the species and fill in
# with question marks as necessary. A file name to write out a TNT log can be
# given with the `log` parameter. writeland.tnt will also add an ECHO command.
# `dec` is used to round the values
writeland.tnt <- function (A, file, dec = 3, allow_missing = FALSE, log = NULL) {
  .writearray.tnt <- function (A, n, global_names, file) {
    # Write an array of landmark data in TNT format to an open file connection.
    A <- round(A, dec)
    k <- dim(A)[2] # Number of dimensions
    p <- dim(A)[1] # Number of landmarks
    dimnames(A)[[3]] <- gsub(" ", "_", dimnames(A)[[3]]) -> item_names
    
    if (k == 2) {
      writeLines("& [landmark 2D]", file)
    } else {
      writeLines("& [landmark 3D]", file)
    }
    for (i in 1:n) { # Iterate over terminal items
      this_line <- global_names[i]
      if (global_names[i] %in% item_names) {
        for (j in 1:p) { # Iterate over landmarks
          coords <- sapply(A[j, , global_names[i]], function (x) ifelse ((x >= 0), paste0("+", x), x))
          coords <- paste(coords, collapse = ",")
          coords <- gsub("NA,NA,NA", "?", coords) # This is for missing landmarks
          this_line <- paste(this_line, coords, collapse = "  ")
        }
      } else {
        this_line <- paste(this_line, paste(rep("?", p), collapse = " "))
      }
      writeLines(this_line, file)
    }
  }
  
  file <- file(file, "w")
  if (! is.null(log)) writeLines(paste0("LOG ", log, ";\nECHO =;"), file)
  writeLines("NSTATES CONT;", file)
  writeLines("XREAD", file)
  tnt_comment <- paste0("\'TNT file generated with the R function `writeland.tnt` on ", date(), ".\'")
  writeLines(tnt_comment, file)
  if (class(A) == "list") {
    item_names <- vector(mode = "character")
    if (allow_missing) {
      for (a in A) {
        item_names <- c(item_names, setdiff(dimnames(a)[[3]], item_names))
      }
    } else {
      item_names <- Reduce(intersect, lapply(A, function (x) dimnames(x)[[3]]))
    }
    item_names <- gsub(" ", "_", item_names)
    n <- length(item_names) # Number of terminal items (sp, ssp, individuals, &c)
    cnames <- names(A)
    writeLines(paste(length(A), n), file)
    for (a in A) {
      .writearray.tnt(a, n, item_names, file)
    }
  } else {
    item_names <- dimnames(A)[[3]]
    item_names <- gsub(" ", "_", item_names)
    n <- length(item_names)
    cnames <- NULL
    writeLines(paste("1", n), file)
    .writearray.tnt(A, n, item_names, file)
  }
  if (! is.null(cnames)) {
    writeLines(";\n\nCNAMES", file)
    for (i in 0:(length(cnames) - 1)) {
      writeLines(paste0("{  ", i, " ", cnames[i + 1], ";"), file)
    }
  }
  writeLines(";\n", file)
  if (! is.null(log)) writeLines("LOG /;", file)
  writeLines("PROC /;\n", file)
  close.connection(file)
}

