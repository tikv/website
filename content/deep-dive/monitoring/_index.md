---
title: Monitoring
weight: 9
---

Monitoring is critical for large distributed systems like TiKV. It alarms ops
when there is an abnormity. It also helps developers do issue diagnosis and find
bottlenecks of the system.

TiKV uses [Prometheus] as the monitoring system and time series database. Data
visualization is achieved by [Grafana].

[Prometheus]: https://github.com/prometheus/prometheus
[Grafana]: https://github.com/grafana/grafana