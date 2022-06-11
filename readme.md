# Advent of Code solutions

In zig, cause we gotta go fast B)
Run code with `zig build run -Drelease-fast`

# Timings

Measurements are taken from an average of 50000 runs on my Ryzen 3700x processor
(~4.2GHz) I compile everything with -OReleaseFast
Every day is programmed as a function that receives a string and returns a pair
of ints. This is what is measured, I decided not to include file I/O in the benchmarks because it causes a lot of variance and is not very interesting (imho) to optimize.

## Results
```
Year 2015
Day  1 in       7 μs Part 1:              74 Part 2:            1795
Day  2 in      27 μs Part 1:         1586300 Part 2:         3737498
Day  3 in     515 μs Part 1:            2592 Part 2:            2360
Day  4 in  479150 μs Part 1:          117946 Part 2:         3938038
Year time: 479701 μs

Year 2020
Day  1 in       4 μs Part 1:          719796 Part 2:       144554112
Day  2 in      24 μs Part 1:             460 Part 2:             251
Day  3 in       2 μs Part 1:             265 Part 2:      3154761400
Day  4 in      51 μs Part 1:             170 Part 2:             103
Day  5 in       3 μs Part 1:             926 Part 2:             657
Day  6 in      49 μs Part 1:            6596 Part 2:            3219
Day  7 in      66 μs Part 1:             119 Part 2:          155802
Day  8 in      50 μs Part 1:            2051 Part 2:            2304
Day  9 in      22 μs Part 1:        85848519 Part 2:        13414198
Day 10 in       1 μs Part 1:            2400 Part 2: 338510590509056
Year time:    275 μs

Year 2021
Day  1 in      21 μs Part 1:            1387 Part 2:            1362
Day  2 in       6 μs Part 1:         1488669 Part 2:      1176514794
Day  3 in      54 μs Part 1:         3969000 Part 2:         4267809
Day  4 in     102 μs Part 1:           49686 Part 2:           26878
Day  5 in     210 μs Part 1:            9723 Part 2:           22116
Day  6 in       1 μs Part 1:          388419 Part 2:   1740449478328
Day  7 in      26 μs Part 1:          343605 Part 2:        96744904
Day  8 in      33 μs Part 1:             284 Part 2:          973499
Day  9 in       6 μs Part 1:             518 Part 2:               0
Year time:    463 μs
-------------------
Total time: 480439 μs
```
