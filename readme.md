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
┌─────────┐
│Year 2015│
├───┬─────┴──────────┬────────────────┬──────────────┐
│Day│     Part 1     │     Part 2     │     Time     │
│  1│             74 │           1795 │      3.590 μs│
│  2│        1586300 │        3737498 │     45.780 μs│
│  3│           2592 │           2360 │    314.540 μs│
│  4│         117946 │        3938038 │ 371379.340 μs│
│  5│            258 │             53 │    113.550 μs│
└───┴────────────────┴──────┬─────────┼─────────── + ┤
                            │Year time│ 371856.800 μs│
                            └─────────┴──────────────┘
┌─────────┐
│Year 2016│
├───┬─────┴──────────┬────────────────┬──────────────┐
│Day│     Part 1     │     Part 2     │     Time     │
│  1│            239 │            141 │      5.160 μs│
└───┴────────────────┴──────┬─────────┼─────────── + ┤
                            │Year time│      5.160 μs│
                            └─────────┴──────────────┘
┌─────────┐
│Year 2020│
├───┬─────┴──────────┬────────────────┬──────────────┐
│Day│     Part 1     │     Part 2     │     Time     │
│  1│         719796 │      144554112 │      2.600 μs│
│  2│            460 │            251 │     16.530 μs│
│  3│            265 │     3154761400 │      1.250 μs│
│  4│            170 │            103 │     35.890 μs│
│  5│            926 │            657 │      2.320 μs│
│  6│           6596 │           3219 │     25.130 μs│
│  7│            119 │         155802 │     41.620 μs│
│  8│           2051 │           2304 │     32.890 μs│
│  9│       85848519 │       13414198 │     45.410 μs│
│ 10│           2400 │338510590509056 │      1.000 μs│
└───┴────────────────┴──────┬─────────┼─────────── + ┤
                            │Year time│    204.640 μs│
                            └─────────┴──────────────┘
┌─────────┐
│Year 2021│
├───┬─────┴──────────┬────────────────┬──────────────┐
│Day│     Part 1     │     Part 2     │     Time     │
│  1│           1387 │           1362 │     36.900 μs│
│  2│        1488669 │     1176514794 │      5.260 μs│
│  3│        3969000 │        4267809 │     97.190 μs│
│  4│          49686 │          26878 │     88.490 μs│
│  5│           9723 │          22116 │    137.990 μs│
│  6│         388419 │  1740449478328 │      0.660 μs│
│  7│         343605 │       96744904 │     23.100 μs│
│  8│            284 │         973499 │     19.510 μs│
│  9│            518 │              0 │      2.940 μs│
└───┴────────────────┴──────┬─────────┼─────────── + ┤
                            │Year time│    412.040 μs│
                            └─────────┴──────────────┘
┌─────────┐
│Year 2022│
├───┬─────┴──────────┬────────────────┬──────────────┐
│Day│     Part 1     │     Part 2     │     Time     │
│  1│          74711 │         209481 │     31.660 μs│
│  2│          11063 │          10349 │      2.500 μs│
│  3│           7737 │           2697 │     24.000 μs│
│  5│      HBTMTBSDC │      PQTJRSHWS │     25.430 μs│
│  6│           1042 │           2980 │      3.560 μs│
│  7│        1477771 │        3579501 │     17.320 μs│
│  9│           6284 │           2661 │    413.440 μs│
│ 10│          12880 │       FCJAPJRE │      1.080 μs│
│ 11│         110220 │    19457438264 │   2587.290 μs│
│ 12│            481 │            480 │     21.760 μs│
└───┴────────────────┴──────┬─────────┼─────────── + ┤
                            │Year time│   3128.040 μs│
                            └─────────┴──────────────┘
┌─────────┐
│Year 2023│
├───┬─────┴──────────┬────────────────┬──────────────┐
│Day│     Part 1     │     Part 2     │     Time     │
│  1│          54239 │          55524 │     44.530 μs│
│  2│           2268 │          63542 │     14.850 μs│
│  3│         528819 │       80403602 │     85.880 μs│
│  4│          21105 │        5329815 │      2.600 μs│
│  6│         503424 │       32607562 │      0.170 μs│
│  7│      250602641 │      251037509 │     49.070 μs│
└───┴────────────────┴──────┬─────────┼─────────── + ┤
                            │Year time│    197.100 μs│
                            └─────────┴──────────────┘
┌─────────┐
│Year 2024│
├───┬─────┴──────────┬────────────────┬──────────────┐
│Day│     Part 1     │     Part 2     │     Time     │
│  1│        1722302 │       20373490 │     38.833 μs│
│  2│            332 │            398 │     54.226 μs│
│  3│      153469856 │       77055967 │     20.955 μs│
└───┴────────────────┴──────┬─────────┼─────────── + ┤
                            │Year time│    114.014 μs│
                            └─────────┴──────────────┘
```

<!-- Total time: 375803.780 μs -->
