# Advent of Code solutions

Will we reach day 3 this year? :eyes:

Run code with `zig build-exe main.zig --single-threaded -OReleaseFast && ./main`
Code assumes linux.

# Timings

Measurements are taken in a non scientific way. I run the benchmark a
few times on my Ryzen 3700x processor (~4.2GHz) and then take the
average of a couple run after I throw away the worst outliers. I compile
everything with -OReleaseFast, I've noticed that on some benchmarks you
can save a couple of μs compiling with -OReleaseSafe for some reason.

## 2020
```
Day  1 in          4 μs (is faster with -OReleaseSafe)
Day  2 in         25 μs
Day  3 in          1 μs
Day  4 in         57 μs
Day  5 in          9 μs
Day  6 in         53 μs
```
