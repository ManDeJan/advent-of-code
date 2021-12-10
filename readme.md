# Advent of Code solutions

In zig, cause we gotta go fast B)
Run code with `zig build-exe main.zig --single-threaded -OReleaseFast && ./main`

# Timings

Measurements are taken from an average of 50000 runs on my Ryzen 3700x processor
(~4.2GHz) I compile everything with -OReleaseFast
Every day is programmed as a function that receives a string and returns a pair
of ints. This is what is measured, I decided not to include file I/O in the benchmarks because it causes a lot of variance and is not very interesting to optimize.

## 2021
```
--- Day  1 2021 in    16 μs Part 1:            1387 Part 2:            1362
--- Day  2 2021 in     6 μs Part 1:         1488669 Part 2:      1176514794
--- Day  3 2021 in    51 μs Part 1:         3969000 Part 2:         4267809
--- Day  4 2021 in   110 μs Part 1:           49686 Part 2:           26878
--- Day  5 2021 in   197 μs Part 1:            9723 Part 2:           22116
--- Day  6 2021 in     0 μs Part 1:          388419 Part 2:   1740449478328
--- Day  7 2021 in    21 μs Part 1:          343605 Part 2:        96744904
--- Day  8 2021 in    30 μs Part 1:             284 Part 2:          973499
--- Total time: 435 μs
```

## 2020
```
--- Day  1 2020 in     2 μs Part 1:          719796 Part 2:       144554112
--- Day  2 2020 in    21 μs Part 1:             460 Part 2:             251
--- Day  3 2020 in     1 μs Part 1:             265 Part 2:      3154761400
--- Day  4 2020 in    36 μs Part 1:             170 Part 2:             103
--- Day  5 2020 in     2 μs Part 1:             926 Part 2:             657
--- Day  6 2020 in    36 μs Part 1:            6596 Part 2:            3219
--- Day  7 2020 in    58 μs Part 1:             119 Part 2:          155802
--- Day  8 2020 in    41 μs Part 1:            2051 Part 2:            2304
--- Day  9 2020 in    19 μs Part 1:        85848519 Part 2:        13414198
--- Day 10 2020 in     0 μs Part 1:            2400 Part 2: 338510590509056
--- Total time: 222 μs
```
