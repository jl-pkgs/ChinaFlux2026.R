#' @importFrom data.table CJ
#' @importFrom magrittr `%>%`
#' @importFrom dplyr rename
array2dt <- function(arr, dimnames) {
  # 注意顺序要匹配，aperm非常必要!
  do.call(CJ, c(dimnames, sorted = FALSE)) %>%
    cbind(value = c(aperm(arr)))
}

#' 从多个栅格文件截取sp所在位置的数据
#'
#' @importFrom terra rast extract time
#' @importFrom Ipaper foreach glue icount `%do%` dir2 runningId
#' @export
extract_rasts <- function(fs, sp, dates = NULL) {
  lst <- foreach(f = fs, i = icount()) %do% {
    runningId(i)
    ra <- rast(f)
    tryCatch({
      extract(ra, sp)[, -1]
    }, error = function(e) {
      message(sprintf("%s", e$message))
    })
  }
  arr <- do.call(cbind, lst) %>% as.matrix() # return arr

  if (!is.null(dates)) {
    dimnames <- list(site = sp$site, date = dates)
    df <- array2dt(arr, dimnames)
    return(df)
  } else {
    return(arr)
  }
}

#' @rdname extract_rasts
#' @export
extract_rast <- function(ra, sp) {
  res <- extract(ra, sp)[, -1]
  arr <- as.matrix(res) # return arr

  dimnames <- list(site = sp$site, date = terra::time(ra))
  df <- array2dt(arr, dimnames)
  return(df)
}
