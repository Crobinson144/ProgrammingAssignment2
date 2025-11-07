# Programming Assignment 2: Lexical Scoping

This repository contains my solution for **Programming Assignment 2** in the Johns Hopkins *R Programming* course (Data Science Specialization).

## Overview
Matrix inversion can be computationally expensive when performed repeatedly.  
This assignment demonstrates how to use **lexical scoping** in R to cache the results of expensive computations—in this case, the inverse of a matrix.

## Files
- **cachematrix.R**  
  Implements two functions:
  - `makeCacheMatrix(x = matrix())`:  
  Creates a special "matrix" object that can store its inverse.
- `cacheSolve(x, ...)`:  
  Computes the inverse of the matrix returned by `makeCacheMatrix()`.  
If the inverse has already been
