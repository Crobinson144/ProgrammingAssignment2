## ===============================================================
## Programming Assignment 2: Lexical Scoping
## ===============================================================
##
## Author: [Your Name]
## Date: [Today's Date]
##
## Purpose:
##   Demonstrate how lexical scoping in R can be used to cache the
##   inverse of a matrix to avoid unnecessary computation.
##
## Description:
##   This script defines two key functions:
##     1. makeCacheMatrix() – Creates a special matrix object
##        that can store both a matrix and its inverse.
##     2. cacheSolve() – Computes or retrieves the cached inverse
##        of the matrix stored in that object.
##
## Why caching matters:
##   Matrix inversion is computationally expensive.  By storing
##   the result after the first computation, we can reuse it in
##   subsequent calls, greatly improving performance.
##
## ===============================================================


## ---------------------------------------------------------------
## Function: makeCacheMatrix
##
## Description:
##   Creates a special "matrix" object that stores both the matrix
##   itself and a cached version of its inverse.
##
## Arguments:
##   x - a numeric matrix (default: an empty matrix)
##
## Returns:
##   A list containing four functions:
##     1. set(y):    assign a new matrix and clear the cache
##     2. get():     retrieve the current matrix
##     3. setinv(i): store the inverse matrix in cache
##     4. getinv():  retrieve the cached inverse
##
## Example:
##   m <- makeCacheMatrix(matrix(c(1,2,3,4),2,2))
##
makeCacheMatrix <- function(x = matrix()) {
  inv <- NULL  # Cached inverse, initially empty
  
  # Replace the matrix and clear any previously cached inverse
  set <- function(y) {
    if (!is.matrix(y)) stop("Input must be a matrix.")
    x <<- y
    inv <<- NULL
  }
  
  # Retrieve the stored matrix
  get <- function() x
  
  # Store a calculated inverse for later retrieval
  setinv <- function(inverse) inv <<- inverse
  
  # Return the cached inverse (or NULL if none)
  getinv <- function() inv
  
  # Return a list of these four functions
  list(set = set,
       get = get,
       setinv = setinv,
       getinv = getinv)
}


## ---------------------------------------------------------------
## Function: cacheSolve
##
## Description:
##   Computes the inverse of the special "matrix" object returned
##   by makeCacheMatrix().  If the inverse has already been
##   computed and cached, it retrieves it instead of recalculating.
##
## Arguments:
##   x - a special matrix object from makeCacheMatrix()
##   ... - optional arguments passed to solve()
##
## Returns:
##   The inverse of the stored matrix.
##
## Notes:
##   - If the matrix has changed since the last inversion, a new
##     inverse will be computed and cached automatically.
##   - A message is printed when a cached value is used.
##
## Example:
##   cacheSolve(m)  # first call: computes
##   cacheSolve(m)  # second call: uses cached version
##
cacheSolve <- function(x, ...) {
  inv <- x$getinv()
  
  # If a cached inverse exists, return it immediately
  if (!is.null(inv)) {
    message("Getting cached inverse")
    return(inv)
  }
  
  mat <- x$get()
  
  # Basic validation checks
  if (!is.matrix(mat)) stop("Input must be a matrix.")
  if (nrow(mat) != ncol(mat)) stop("Matrix must be square.")
  
  # Compute the inverse using the base R 'solve' function
  inv <- solve(mat, ...)
  
  # Store the inverse in cache for future calls
  x$setinv(inv)
  
  # Return the computed inverse
  inv
}
