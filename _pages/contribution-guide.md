---
layout: default
title: "Apache Beam Contribution Guide"
permalink: /contribution-guide/
---

# How to Contribute

## Overview
The Apache Beam community welcomes contributions from anyone with a passion for data processing! Beam has many different opportunities for contributions -- write new examples, add new user-facing libraries (new statistical libraries, new IO connectors, etc), work on the core programming model, build specific runners (Apache Flink, Apache Spark, Google Cloud Dataflow, etc), or participate on the documentation effort.

We use a review-then-commit workflow in Beam for all contributions.

![Alt text]({{ "/images/contribution-guide-1.png" | prepend: site.baseurl }} "Optional title")

**For larger contributions or those that affect multiple components:**

1. **Engage**: We encourage you to work with the Beam community on the [Apache JIRA issue tracker](https://issues.apache.org/jira/browse/BEAM) and [developer’s mailing list](http://beam.incubator.apache.org/mailing_lists/) to identify good areas for contribution.
1. **Design:** More complicated contributions will likely benefit from some early discussion in order to scope and design them well.

**For all contributions:**

1. **Code:** The best part ;-)
1. **Review:** Submit a pull request with your contribution to our [GitHub mirror](https://github.com/apache/incubator-beam/). Work with a committer to review and iterate on the code, if needed.
1. **Commit:** A Beam committer merges the pull request into our [Apache repository](https://git-wip-us.apache.org/repos/asf/incubator-beam.git).

We look forward to working with you!

## Engage

### Mailing list(s)
We discuss design and implementation issues on dev@beam.incubator.apache.org mailing list, which is archived [here](http://mail-archives.apache.org/mod_mbox/incubator-beam-dev/). Join by emailing [`dev-subscribe@beam.incubator.apache.org`](mailto:dev-subscribe@beam.incubator.apache.org).

If interested, you can also join [`user@beam.incubator.apache.org`](http://mail-archives.apache.org/mod_mbox/incubator-beam-user/) and [`commits@beam.incubator.apache.org`](http://mail-archives.apache.org/mod_mbox/incubator-beam-commits/) too.

### Apache JIRA
We use [Apache JIRA](https://issues.apache.org/jira/browse/BEAM) as an issue tracking and project management tool, as well as a way to communicate among a very diverse and distributed set of contributors. To be able to gather feedback, avoid frustration, and avoid duplicated efforts all Beam-related work should be tracked there.

If you do not already have an Apache JIRA account, sign up [here](https://issues.apache.org/jira/).

If a quick [search](https://issues.apache.org/jira/issues/?jql=project%3DBEAM%20AND%20text%20~%20%22the%20thing%20I%20want%20to%20contribute%22) doesn’t turn up an existing JIRA issue for the work you want to contribute, create it. Please discuss your proposal with a committer or the [component lead](https://issues.apache.org/jira/browse/BEAM/?selectedTab=com.atlassian.jira.jira-projects-plugin:components-panel) in JIRA or, alternatively, on the developer mailing list.

If there’s an existing JIRA issue for your intended contribution, please comment about your intended work. Once the work is understood, a committer will assign the issue to you. (If you don’t have a JIRA role yet, you’ll be added to the “contributor” role.) If an issue is currently assigned, please check with the current assignee before reassigning.

For moderate or large contributions, you should not start coding or writing a design doc unless there is a corresponding JIRA issue assigned to you for that work. Simple changes, like fixing typos, do not require an associated issue.

### Design
To avoid potential frustration during the code review cycle, we encourage you to clearly scope and design non-trivial contributions with the Beam community before you start coding.

Generally, the JIRA issue is the best place to gather relevant design docs, comments, or references. It’s great to explicitly include relevant stakeholders early in the conversation. For designs that may be generally interesting, we also encourage conversations on the developer’s mailing list.

We suggest using [Google Docs](https://docs.google.com/) for sharing designs that may benefit from diagrams or comments. Please remember to make the document world-commentable and add a link to it from the relevant JIRA issue. We also track Beam-related documents in [this shared folder](https://drive.google.com/folderview?id=0B-IhJZh9Ab52OFBVZHpsNjc4eXc&usp=sharing).

### Code
To contribute code to Apache Beam, you’ll have to do a few administrative steps once, and then follow a few guidelines for each contribution.
