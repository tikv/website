---
title: TiKV Security Audit Results
author: TiKV Authors
date: 2020-03-05
---

Today we're glad to announce that TiKV just finished a third-party security assessment, funded by CNCF/The Linux Foundation.

From Feb 10 to March 03, 2019, the team from Cure53 performed comprehensive tests on TiKV in the following aspects:

- General security posture checks that entail:
  - Language specifics (Rust)
  - External Libraries & Frameworks
  - Configuration Concerns
  - Access Control
  - Logging/Monitoring
  - Unit/Regression and Fuzz-Testing
  - Documentation
  - Security Contact/Fix Handling
  - Bug Tracking & Review Process
- Manual code auditing & penetration testing

This independent security audit was performed on locally installed systems, as well as with a typical production enviroment provided by the TiKV team.

Here are some highlights:

 > *The security posture of the TiKV has been positively evaluated by the involved five members of the Cure53 team. Similarly, high-quality premise was noted for the codebase and documentation, therefore the state of the TiKV software stack can be summarized as mature.*

> *Starting with enumerating some of the positive aspects and findings, Cure53 would like to underline that the TiKV project makes a sound and strong appearance at the meta-level as regards code quality, coding patterns, style coherence, and general structure. This is also reinforced by the fact that static code analysis in the later parts of the audit phase did not reveal significant problems.*

> *In light of the findings from this February 2020 assessment, Cure53 can recommend TiKV for public deployment, especially when integrated into a containerized solution via Kubernetes and Prometheus for additional monitoring.*

Cure53 also identified a noteworthy issue and some areas of improvement for the TiKV team to work on:

- **TIK-01-001 SCA**: *Security vulnerabilities in outdated library versions: Analyzing the libraries in use revealed that multiple ones do not leverage the most recent versions available. Some libraries are no longer actively maintained and pose a threat to the future security posture of the project.*

To address this, we will upgrade the outdated vulnerable dependencies and integrate `cargo-audit` into CI. We have created issues [#7004](https://github.com/tikv/tikv/issues/7004) and [#7005](https://github.com/tikv/tikv/issues/7005) are created on Github to track the progress.

- *TiKV integrates multiple different fuzzing libraries to test their project extensively, namely LLVMs libfuzzer, AFL and Googles Honggfuzz. However, the tests do not run in an automated pipeline and are currently run sporadically in a manual fashion*

We would reintegrate the tests into an automated CI task, running them at least in a monthly rhythm as suggested by cure53. Issue [#7007](https://github.com/tikv/tikv/issues/7004) is created to track the progress.

There are also some minor security concerns with regards to configuration, documenation, security handling process, etc. We are thankful for these findings. To follow up, we have created a GitHub project, [Security TIK-01](https://github.com/tikv/tikv/projects/29), to keep track of all the issues that are valid for improvements.

The full report is available [here](./TiKV-Security-Audit.pdf).

We would like to thank Cure53, CNCF, The Linux Foundation, and all TiKV contributors for their efforts in making this happen.

