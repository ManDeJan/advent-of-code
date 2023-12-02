# Advent of Code solutions

In zig, cause we gotta go fast B)
Run code with `zig build run -Doptimize=ReleaseFast`

# Timings

Measurements are taken from an average of 100 runs on my Ryzen 5950x processor
(~4.2GHz) I compile everything with -OReleaseFast
Every day is programmed as a function that receives a string and returns a pair
of ints. This is what is measured, I decided not to include file I/O in the benchmarks because it causes a lot of variance and is not very interesting (imho) to optimize.

## Results
```
Year 2015
Day  1 in       3 μs Part 1:              74 Part 2:            1795
Day  2 in      41 μs Part 1:         1586300 Part 2:         3737498
Day  3 in     306 μs Part 1:            2592 Part 2:            2360
Day  4 in  372197 μs Part 1:          117946 Part 2:         3938038
Day  5 in     116 μs Part 1:             258 Part 2:              53
Year time: 372665 μs

Year 2016
Day  1 in       5 μs Part 1:             239 Part 2:             141
Year time:      5 μs

Year 2020
Day  1 in       2 μs Part 1:          719796 Part 2:       144554112
Day  2 in      17 μs Part 1:             460 Part 2:             251
Day  3 in       1 μs Part 1:             265 Part 2:      3154761400
Day  4 in      38 μs Part 1:             170 Part 2:             103
Day  5 in       2 μs Part 1:             926 Part 2:             657
Day  6 in      24 μs Part 1:            6596 Part 2:            3219
Day  7 in      44 μs Part 1:             119 Part 2:          155802
Day  8 in      33 μs Part 1:            2051 Part 2:            2304
Day  9 in      49 μs Part 1:        85848519 Part 2:        13414198
Day 10 in       0 μs Part 1:            2400 Part 2: 338510590509056
Year time:    215 μs

Year 2021
Day  1 in      19 μs Part 1:            1387 Part 2:            1362
Day  2 in       5 μs Part 1:         1488669 Part 2:      1176514794
Day  3 in      96 μs Part 1:         3969000 Part 2:         4267809
Day  4 in      87 μs Part 1:           49686 Part 2:           26878
Day  5 in     152 μs Part 1:            9723 Part 2:           22116
Day  6 in       0 μs Part 1:          388419 Part 2:   1740449478328
Day  7 in      17 μs Part 1:          343605 Part 2:        96744904
Day  8 in      19 μs Part 1:             284 Part 2:          973499
Day  9 in       3 μs Part 1:             518 Part 2:               0
Year time:    403 μs

Year 2022
Day  1 in      26 μs Part 1:           74711 Part 2:          209481
Day  2 in       3 μs Part 1:           11063 Part 2:           10349
Day  3 in      23 μs Part 1:            7737 Part 2:            2697
Day  5 in      17 μs Part 1:       HBTMTBSDC Part 2:       PQTJRSHWS
Day  6 in       4 μs Part 1:            1042 Part 2:            2980
Day  7 in      13 μs Part 1:         1477771 Part 2:         3579501
Day  9 in     416 μs Part 1:            6284 Part 2:            2661
Day 10 in       1 μs Part 1:           12880 Part 2:        FCJAPJRE
Day 11 in    2549 μs Part 1:          110220 Part 2:     19457438264
Day 12 in      22 μs Part 1:             481 Part 2:             480
Year time:   3078 μs

Year 2023
Day  1 in      44 μs Part 1:           54239 Part 2:           55524
Day  2 in      15 μs Part 1:            2268 Part 2:           63542
Year time:     59 μs
--------------------
Total time: 376427 μs
```
