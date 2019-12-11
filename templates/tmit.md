---
title: This Month in TiKV - $MONTH $YEAR
date: 2019-11-20
author: $AUTHOR
---

<!-- Fill in the below from the API: https://developer.github.com/v4/explorer/ -->

<!-- Witty welcome slogan -->

## Releases

This month our team made ${NUMBER} TiKV releases! <!-- Explain if minor or major -->

You can review the changelogs here:
<!--
Find ones from this month, link them as a list:

query recent_releases {
  repository(name: "tikv", owner: "tikv") {
    releases(last: 5) {
      edges {
        node {
          name
          publishedAt
          url
        }
      }
    }
  }
}

Format:

* [$VERSION]($URL)
-->

Upgrading? Things to note:

<!-- Note if there are any new features, or breaking changes listed in those changelogs. List them! 

Format:

* $DESCRIPTION ($PR)

-->

## News

<!-- Any specific updates about tikv in general, it's OK to skip this section entirely -->

## Reading materials

<!-- Check known source of TiKV material and look for new content from the month -->

## Notable PRs

<!--
Explore notable PRs found via the query (change the month/year), try to identify PRs that folks can easily understand.

query issues {
  search(query: "repo:tikv/tikv created:2019-11 is:pr sort:interactions", type: ISSUE, first: 100) {
    edges {
      node {
        ... on PullRequest {
          title
          url
          author {
            login
            url
          }
        }
      }
    }
  }
}

Format:

* [$PR]($URL) by [$USER] $DESCRIPTION.
-->

## Notable issues

<!--
Explore notable issues found via the query (change the month/year), try to identify issues that folks can easily understand.

query issues {
  search(query: "repo:tikv/tikv created:2019-11 is:issue sort:interactions", type: ISSUE, first: 100) {
    edges {
      node {
        ... on Issue {
          title
          url
          author {
            login
            url
          }
        }
      }
    }
  }
}

Format:

* [$ISSUE]($URL) by [$USER] $DESCRIPTION.
-->

## Current projects

Here's some of the things our contributors have been working on over the last month:

<!-- Try to contextualize some of those above issues/PRs. Also try to include others.

Format:

* [$USERS] $PROJECT_DESCRIPTION ($MAYBE_LINK)
-->

If any of these projects sound like something you'd like to contribute to, let us know on our [chat](https://tikv.org/chat) and we'll try to help you get involved.

## New contributors

We'd like to welcome the following new contributors to TiKV and thank them for their work!

<!-- Go to https://tikv.devstats.cncf.io/d/52/new-contributors-table?orgId=1&from=1572591600000&to=1575273599000 and update the date to the correct month.

Format:

* [$USER]
-->

If you'd like to get involved, we'd love to help you get started. You might be interested in tackling one of [these issues](https://github.com/tikv/tikv/issues?q=is%3Aopen+is%3Aissue+label%3A%22D%3A+Easy%22+label%3A%22S%3A+HelpWanted%22). If you don't know how to begin, please leave a comment and somebody will help you out. We're also very keen for people to contribute documentation, tests, optimizations, benchmarks, refactoring, or other useful things.

## This Week in TiDB

For more detailed and comprehensive information about TiDB and TiKV, we have weekly updates. The following cover $MONTH:

<!-- Check https://pingcap.com/weekly/ and add the reports below:

* [$WEEK]($URL)
