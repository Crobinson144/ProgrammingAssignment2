# ============================================================
# Programming Assignment 2: Lexical Scoping
# ============================================================
# This script contains two main functions:
#   1. makeCacheMatrix() - creates a special matrix object that can cache its inverse.
#   2. cacheSolve()      - computes (and caches) the inverse of that matrix.
#
# The code uses lexical scoping and the <<- operator to maintain state between
# function calls.
#
# Additional helper function (.is_invertible) checks whether a matrix is
# invertible before attempting to compute its inverse, providing safe error
# handling and user-friendly messages.
# ============================================================


# ------------------------------------------------------------
# makeCacheMatrix()
# ------------------------------------------------------------
# Creates a special "matrix" object that can store its inverse.
# ------------------------------------------------------------

makeCacheMatrix <- function(x = matrix()) {
  inv <- NULL  # cached inverse
  
  .validate_matrix <- function(m) {
    if (!is.matrix(m)) stop("Input must be a matrix.")
    if (!is.numeric(m)) stop("Matrix must be numeric.")
    if (nrow(m) != ncol(m)) stop("Matrix must be square.")
    invisible(TRUE)
  }
  
  # Validate if x provided at creation
  if (length(x)) .validate_matrix(x)
  
  # Set matrix (and clear cache if new matrix differs)
  set <- function(y) {
    .validate_matrix(y)
    if (!identical(x, y)) {
      x   <<- y
      inv <<- NULL
    }
  }
  
  # Accessor functions
  get    <- function() x
  setinv <- function(inverse) inv <<- inverse
  getinv <- function() inv
  
  list(set = set, get = get, setinv = setinv, getinv = getinv)
}


# ------------------------------------------------------------
# .is_invertible()
# ------------------------------------------------------------
# Helper to check if a numeric square matrix is invertible.
# ------------------------------------------------------------
.is_invertible <- function(A, rank_tol = .Machine$double.eps^0.5,
                           cond_warn = 1e12, verbose = TRUE) {
  n <- nrow(A)
  # Check full rank
  r <- qr(A, tol = rank_tol)$rank
  if (r < n) {
    if (isTRUE(verbose))
      message("Matrix is not full rank (singular). Skipping inversion.")
    return(FALSE)
  }
  # Warn if ill-conditioned
  k <- tryCatch(kappa(A), error = function(e) Inf)
  if (is.finite(k) && k > cond_warn && isTRUE(verbose)) {
    message(sprintf(
      "Warning: matrix is ill-conditioned (kappa ≈ %.2e). Inverse may be unstable.",
      k
    ))
  }
  TRUE
}


# ------------------------------------------------------------
# cacheSolve()
# ------------------------------------------------------------
# Computes the inverse of the matrix returned by makeCacheMatrix().
# If already cached, it retrieves the cached result.
# ------------------------------------------------------------
cacheSolve <- function(x, ..., use_message = TRUE, safe_check = TRUE) {
  inv <- x$getinv()
  if (!is.null(inv)) {
    if (isTRUE(use_message)) message("getting cached inverse")
    return(inv)
  }
  
  mat <- x$get()
  if (!length(mat)) {
    if (isTRUE(use_message))
      message("No matrix set; use the object's set() first.")
    return(NULL)
  }
  
  # Optional safety check
  if (isTRUE(safe_check)) {
    if (!.is_invertible(mat, verbose = use_message)) {
      return(NULL)
    }
  }
  
  inv <- tryCatch(
    solve(mat, ...),
    error = function(e) {
      if (isTRUE(use_message))
        message("Matrix inversion failed: ", conditionMessage(e))
      return(NULL)
    }
  )
  
  if (!is.null(inv)) x$setinv(inv)
  inv
}


# ============================================================
# Example usage (you can test these in the Console)
# ============================================================
# source("cachematrix.R")
# m <- matrix(c(2, 1, 1, 2), 2, 2)
# cm <- makeCacheMatrix(m)
# cacheSolve(cm)     # Computes inverse
# cacheSolve(cm)     # Retrieves cached inverse
#
# m_sing <- matrix(c(4, 2, 2, 1), 2, 2)  # Singular matrix
# cm_sing <- makeCacheMatrix(m_sing)
# cacheSolve(cm_sing) # Should warn and return NULL
# ============================================================
