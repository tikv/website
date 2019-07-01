---
title: Prometheus
weight: 1
---

# Prometheus

[Prometheus] is the monitoring system used in TiKV. It is an open-source
systems monitoring and alerting toolkit. Widely adopted by cloud native
applications, Prometheus is a graduated project of the [CNCF].

The TiKV team develop and maintain [rust-prometheus], the Rust clien for
Prometheus. The library is heavily used in TiKV to collect various metrics. 

## Data Model

Prometheus stores all data as time series. Time series data are formed with
_samples_. Each sample consists of a float64 value and a millisecond-precision
timestamp.

Every time series is uniquely identified by its _metric name_ and a set of
_labels_. Given a metric name and a set of labels, time series are frequently
identified using this notation:

```
<metric name>{<label name>=<label value>, ...}
```

## Metrics

Prometheus offers four [metric types][mt]: Counter, Gauge, Histogram and
Summary. The first three types of metrics are supported by rust-prometheus.

Next, let us see how we use these metrics in TiKV for statistics and issue
diagnosis.

### Counter

A counter stores the totality of some value at each point in time. Therefore,
it is easy to calculate the _increment_ during a period. Divided by time,
we can also get its growth rate.

For example, TiKV [defines][ce] the `tikv_engine_cache_efficiency` counter
[to count][inc] block cache hits and misses of RocksDB. When there are block
cache misses, RocksDB needs to read the disk and thus slows down the query.

We can use [PromQL] to query the memtable hit rate in the last minute:

```
sum(rate(tikv_engine_memtable_efficiency{instance=~"$instance", db="$db",
type="memtable_hit"}[1m])) / (sum(rate(tikv_engine_memtable_efficiency{db="$db",
type="memtable_hit"}[1m])) + sum(rate(tikv_engine_memtable_efficiency{db="$db",
type="memtable_miss"}[1m])))
```

`[1m]` is a [range vector selector][rvs] which selects samples within the last
minute. [`rate()`][rate] calculates the per-second increase rate in the range
vector. Finally, we use `sum()` because there could be data of various
instances and databases.

### Gauge

Unlike a counter, a gauge does not require the value to monotonically increase.
It can store time series of arbitrary numerical values.

In TiKV, the number of scheduler pending commands, which can go both up and
down, is represented by the [`tikv_scheduler_contex_total` gauge][sg]. Its
value is increased when a command is [enqueued][enq] and is decreased when a
command is [dequeued][deq] from the scheduler.

The total number of pending commands can be queried by:

```
sum(tikv_scheduler_contex_total{instance=~"$instance"}) by (instance)
```

### Histogram

A histogram is composed of multiple counters: the sum of all observed values,
the count of observed events, and some cumulative counters of configurable
buckets.

At the creation of a histogram, you need to set the upper bound of each bucket.
Every time a value is observed, the counters of the matching buckets are
incresed.

For example, the upper bounds of the buckets are `0.05`, `0.2`, `1` and `5`.
If a value `0.5` is observed, the value will be added to the sum, the total
event count will be increased, and the counters of buckets `(-∞, 1]`, `(-∞, 5]`
will also be increased.

Usually, a histogram is used if we need to be calculate quantiles. Given a φ
between 0 and 1, [`histogram_quantile()`][hq] can find which bucket the
φ-quantile is in, and use linear interpolation to estimate the φ-quantile
value.

TiKV records [gRPC message durations][dur] using histograms. Twenty buckets
are created and the upper bound of each bucket is twice as the previous one.
A timer is started when a request is received. When the message finishes
being processed, the duration is [recorded][obs] to Prometheus as an observed
value. We can get the 99th percentiles of gRPC messages with [PromQL] like this:

```
histogram_quantile(
    0.99,
    sum(rate(tikv_grpc_msg_duration_seconds_bucket{instance=~"$instance"}[1m]))
    by (le, type)
)
```


[Prometheus]: https://github.com/prometheus/prometheus
[CNCF]: https://www.cncf.io/
[rust-prometheus]: https://github.com/pingcap/rust-prometheus
[mt]: https://prometheus.io/docs/concepts/metric_types/
[ce]: https://github.com/tikv/tikv/blob/v3.0.0/components/engine/src/rocks/util/engine_metrics.rs#L1020
[inc]: https://github.com/tikv/tikv/blob/v3.0.0/components/engine/src/rocks/util/engine_metrics.rs#L122
[PromQL]: https://prometheus.io/docs/prometheus/latest/querying/basics/
[rvs]: https://prometheus.io/docs/prometheus/latest/querying/basics/#range-vector-selectors
[rate]: https://prometheus.io/docs/prometheus/latest/querying/functions/#rate
[sg]: https://github.com/tikv/tikv/blob/v3.0.0/src/storage/metrics.rs#L63
[enq]: https://github.com/tikv/tikv/blob/v3.0.0/src/storage/txn/scheduler.rs#L196
[deq]: https://github.com/tikv/tikv/blob/v3.0.0/src/storage/txn/scheduler.rs#L215
[hq]: https://prometheus.io/docs/prometheus/latest/querying/functions/#histogram_quantile
[dur]: https://github.com/tikv/tikv/blob/v3.0.0/src/server/metrics.rs#L60
[obs]: https://github.com/tikv/tikv/blob/v3.0.0/src/server/service/kv.rs#L93