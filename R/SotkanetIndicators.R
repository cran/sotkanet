#' @title Sotkanet Indicators (old version)
#' @description Retrieve Sotkanet indicator metadata. (This is an older version of the function. 
#'  It is advised to use the new [sotkanet_indicators()] function instead.)
#' @details Data is fetched from \url{https://sotkanet.fi/rest/1.1/indicators}.
#' @param id Dataset identifier. Default is NULL returning all
#' @param type type output format, either 'table' (default) or 'raw'.
#'    Default produces a truncated table with strictly defined columns that
#'    are useful in other functions. 'Raw' produces the full output which might
#'    be useful for exploratory purposes.
#' @param user.agent "User agent" defined by the user. Default is NULL which
#'    will then use the package identifier "rOpenGov/sotkanet"
#' @return data.frame (type = "table) or a list (type = "raw")
#'
#' @references See citation("sotkanet")
#'
#' @author Leo Lahti \email{leo.lahti@@iki.fi}, Pyry Kantanen
#' @examples
#' \dontrun{
#' sotkanet.indicators <- SotkanetIndicators(type = "table")
#' }
#' @importFrom httr2 url_parse url_build
#' @keywords utilities
#' @export
SotkanetIndicators <- function(id = NULL, type = "table", user.agent = NULL)
{

  message("This is an old version of the function.\nIt is advised to use the new sotkanet_indicators function instead.")
  
  if (!(type %in% c("table", "raw"))){
    message("Please use valid type input: 'table' or 'raw'")
    return(invisible(NULL))
  }

  # Gather URL parts
  sotkanet_url <- "https://sotkanet.fi/rest"
  sotkanet_uri <- "/1.1/indicators"

  if (!is.null(id)){

    if (length(id) > 1){
      res <- lapply(id, FUN=SotkanetIndicators, type = type, user.agent = user.agent)
      res <- res[!is.na(res)]
      if (type == "table"){
        res <- do.call(rbind.data.frame, res)
      }
      return(res)
    }

    if (type == "raw"){
      sotkanet_uri <- paste(sotkanet_uri, id, sep = "/")

      url_object <- httr2::url_parse(sotkanet_url)
      path <- paste(url_object$path, sotkanet_uri, sep = "")
      url_object$path <- path
      final_url <- httr2::url_build(url_object)

      res <- sotkanet.json_query(final_url,
                                 simplifyVector = TRUE,
                                 user.agent = user.agent)

      return(res)

    } else if (type == "table"){
      sotkanet_uri <- paste(sotkanet_uri, id, sep = "/")
      url_object <- httr2::url_parse(sotkanet_url)
      path <- paste(url_object$path, sotkanet_uri, sep = "")
      url_object$path <- path
      final_url <- httr2::url_build(url_object)

      res <- sotkanet.json_query(final_url,
                                 simplifyVector = TRUE,
                                 user.agent = user.agent)

      # res <- res[which(res$id == id),]

      res <- SotkanetCollect(res, "indicator")

      return(res)
    }
  }

  # Construct URL
  url_object <- httr2::url_parse(sotkanet_url)
  path <- paste(url_object$path, sotkanet_uri, sep = "")
  url_object$path <- path
  final_url <- httr2::url_build(url_object)

  res <- sotkanet.json_query(final_url,
                             simplifyVector = TRUE,
                             user.agent = user.agent)

  if (type == "table") {
    res <- SotkanetCollect(res, "indicator")
  }

  res
}
