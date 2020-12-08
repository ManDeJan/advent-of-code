# Advent of Code solutions

Will we reach day 3 this year? :eyes:

Run code with `zig build-exe main.zig --single-threaded -OReleaseFast && ./main`
Code assumes linux.

# Timings

Measurements are taken from an average of 5000 runs on my Ryzen 3700x processor
(~4.2GHz) I compile everything with -OReleaseFast, I've noticed that on some
benchmarks you can save a couple of μs compiling with -OReleaseSafe for some reason.

## 2020
```
Day  1 in          3 μs (is faster with -OReleaseSafe)
Day  2 in         22 μs
Day  3 in          1 μs
Day  4 in         48 μs
Day  5 in          2 μs
Day  6 in         44 μs
Day  7 in         66 μs
Day  8 in         55 μs
-----------------------
Total time:      245 μs
```
