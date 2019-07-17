---
title: Monitoring
weight: 9
---

Monitoring is critical for large distributed systems like TiKV. It can:

* present useful system health information
* alert operators to cluster anomalies
* help developers do issue diagnosis and performance tuning

TiKV uses [Prometheus] as the monitoring system and time series database. Data
visualization is achieved by [Grafana]. TiKV users usually also use the
[Node exporter] to collect hardware and OS metrics, as well as the
[Alertmanager] to handle alerts:

{{< figure
    src="/img/deep-dive/monitor.png"
    caption="Monitoring systems">}}

[Prometheus]: https://github.com/prometheus/prometheus
[Grafana]: https://github.com/grafana/grafana
[Node exporter]: https://github.com/prometheus/node_exporter
[Alertmanager]: https://github.com/prometheus/node_exporter