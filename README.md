# 📘 Programming Assignment 2: Lexical Scoping

## Overview
This repository contains the completed R code for **Programming Assignment 2** in the *R Programming* course offered by Johns Hopkins University on Coursera.  
The objective of this assignment is to demonstrate the use of **lexical scoping** and **closures** in R to create a system that caches the inverse of a matrix, improving computational efficiency.

---

## 📂 Contents
- **`cachematrix.R`** – Main R script implementing the functions `makeCacheMatrix()` and `cacheSolve()`.  
- **`README.md`** – Documentation describing the purpose, functionality, and usage of the code.

---

## ⚙️ Functional Description

### `makeCacheMatrix(x = matrix())`
Creates a special “matrix” object that can store both a matrix and its cached inverse.

**Functions returned:**
- `set(y)` – Assigns a new matrix and clears any previously stored inverse.  
- `get()` – Retrieves the current matrix.  
- `setinv(inv)` – Stores the inverse of the matrix in cache.  
- `getinv()` – Retrieves the cached inverse if it exists.

This function demonstrates how **closures** maintain state between function calls, an important feature of **lexical scoping** in R.

---

### `cacheSolve(x, ...)`
Computes the inverse of the matrix returned by `makeCacheMatrix()`.  
If the inverse has already been calculated and the matrix has not changed, it retrieves the cached inverse instead of recomputing it.

**Process:**
1. Checks if a cached inverse already exists.  
2. If yes, retrieves it and prints `"Getting cached inverse"`.  
3. If not, computes the inverse using `solve()`, stores it in cache, and returns it.

---

## 🧮 Example Usage

```r
source("cachematrix.R")

# Create a matrix and its special cached object
m <- matrix(c(2, 1, 1, 2), 2, 2)
cm <- makeCacheMatrix(m)

# Compute the inverse for the first time
cacheSolve(cm)

# Retrieve the cached inverse
cacheSolve(cm)
