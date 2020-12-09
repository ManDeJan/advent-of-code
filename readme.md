# Advent of Code solutions

Will we reach day 3 this year? :eyes:

Run code with `zig build-exe main.zig --single-threaded -OReleaseFast && ./main`
Code assumes linux.

# Timings

Measurements are taken from an average of 50000 runs on my Ryzen 3700x processor
(~4.2GHz) I compile everything with -OReleaseFast, I've noticed that on some
benchmarks you can save a couple of μs compiling with -OReleaseSafe for some reason.

Every day is programmed as a function that receives a string and returns a pair
of ints. This is what is measured, I decided not to include file I/O in the benchmarks because it causes a lot of variance and is not very interesting to optimize.

## 2020
```
--- Day  1 2020 in     2 μs Part 1:       719796 Part 2:    144554112
--- Day  2 2020 in    22 μs Part 1:          460 Part 2:          251
--- Day  3 2020 in     1 μs Part 1:          265 Part 2:   3154761400
--- Day  4 2020 in    47 μs Part 1:          170 Part 2:          103
--- Day  5 2020 in     2 μs Part 1:          926 Part 2:          657
--- Day  6 2020 in    46 μs Part 1:         6596 Part 2:         3219
--- Day  7 2020 in    66 μs Part 1:          119 Part 2:       155802
--- Day  8 2020 in    44 μs Part 1:         2051 Part 2:         2304
--- Day  9 2020 in    20 μs Part 1:     85848519 Part 2:     13414198
--- Total time: 256 μs
```
