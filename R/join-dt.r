#' Join data table tbls.
#'
#' See \code{\link{join}} for a description of the general purpose of the
#' functions.
#'
#' @inheritParams join
#' @param x,y tbls to join
#' @param ... Included for compatibility with generic; otherwise ignored.
#' @examples
#' if (require("RSQLite") && require("RSQLite.extfuns")) {
#' data("Batting", package = "Lahman")
#' data("Master", package = "Lahman")
#'
#' batting_dt <- tbl_dt(Batting)
#' person_dt <- tbl_dt(Master)
#'
#' # Inner join: match batting and person data
#' inner_join(batting_dt, person_dt)
#'
#' # Left join: keep batting data even if person missing
#' left_join(batting_dt, person_dt)
#'
#' # Semi-join: find batting data for top 4 teams, 2010:2012
#' grid <- expand.grid(
#'   teamID = c("WAS", "ATL", "PHI", "NYA"),
#'   yearID = 2010:2012)
#' top4 <- semi_join(batting_dt, grid, copy = TRUE)
#'
#' # Anti-join: find batting data with out player data
#' anti_join(batting_dt, person_dt)
#' }
#' @name join.tbl_dt
NULL

join_dt <- function(op) {
  template <- substitute(function(x, y, by = NULL, copy = FALSE, ...) {
    by <- by %||% common_by(x, y)
    y <- auto_copy(x, y, copy = copy)

    x <- copy(x)
    y <- copy(y)
    setkeyv(x, by)
    setkeyv(y, by)
    out <- op
    grouped_dt(out, groups(x))
  })

  f <- eval(template, parent.frame())
  attr(f, "srcref") <- NULL # fix so prints correctly
  f
}

#' @export
#' @rdname join.tbl_dt
inner_join.data.table <- join_dt(merge(x, y, by = by, allow.cartesian = TRUE))

#' @export
#' @rdname join.tbl_dt
left_join.data.table  <- join_dt(merge(x, y, by = by, all.x = TRUE, allow.cartesian = TRUE))

#' @export
#' @rdname join.tbl_dt
semi_join.data.table  <- join_dt({
  # http://stackoverflow.com/questions/18969420/perform-a-semi-join-with-data-table
  w <- unique(x[y, which = TRUE, allow.cartesian = TRUE])
  w <- w[!is.na(w)]
  x[w]
})

#' @export
#' @rdname join.tbl_dt
anti_join.data.table <- join_dt(x[!y, allow.cartesian = TRUE])
