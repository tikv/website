---
title: Monitoring Framework
description: Use Prometheus and Grafana to build the TiKV monitoring framework.
menu:
    "7.1":
        parent: Monitor and Alert-7.1
        weight: 1
        identifier: Monitoring Framework-7.1
---

The TiKV monitoring framework adopts two open-source projects: [Prometheus](https://github.com/prometheus/prometheus) and [Grafana](https://github.com/grafana/grafana). TiKV uses Prometheus to store the monitoring and performance metrics, and uses Grafana to visualize these metrics.

## About Prometheus in TiKV

Prometheus is a time-series database and has a multi-dimensional data model and flexible query language. Prometheus consists of multiple components. Currently, TiKV uses the following components:

- Prometheus Server: to scrape and store time series data
- Client libraries: to customize necessary metrics in the application
- AlertManager: for the alerting mechanism

{{< figure
    src="/img/docs/prometheus-in-tikv2.png"
    caption="Prometheus in TiKV"
    number="" >}}

## About Grafana in TiKV

[Grafana](https://github.com/grafana/grafana) is an open-source project for analyzing and visualizing metrics. TiKV uses Grafana to display the performance metrics.
