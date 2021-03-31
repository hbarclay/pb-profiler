Set of very simple scripts for collecting and visualizing system profiling information

# perf-stats.sh
``` 
./perf-stats.sh n
```

Collects data for `n` seconds from performance counters and computes values like IPC, MPKI, etc.


# toplev-stats.sh

```
./toplev-stats.sh n
```

Collects toplev bottleneck data for `n` seconds and outputs useful plots, currently `bottleneck.png`


# flamegraph.sh
```
./flamegraph.sh n f
```

Collects function profile information at frequency `f` for `n` seconds and generates `flamegraph.svg`


