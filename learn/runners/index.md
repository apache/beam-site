---
layout: default
title: "Beam Runners"
permalink: /learn/runners/
---
# Apache Beam Runners

A Beam Runner runs a Beam pipeline on a specific (often distributed) data processing system.

## Current Runners

* [DirectRunner](/learn/runners/direct/): Runs locally on your machine -- great for developing, testing, and debugging.
* [FlinkRunner](/learn/runners/flink/): Runs on [Apache Flink](http://flink.apache.org).
* [SparkRunner](/learn/runners/spark/): Runs on [Apache Spark](http://spark.apache.org).
* [DataflowRunner](/learn/runners/dataflow/): Runs on [Google Cloud Dataflow](https://cloud.google.com/dataflow), a fully managed service within [Google Cloud Platform](https://cloud.google.com/).
* _[Under Development]_[ApexRunner](/contribute/work-in-progress/#feature-branches): Runs on [Apache Apex](http://apex.apache.org).
* _[Under Development]_[GearpumpRunner](/contribute/work-in-progress/#feature-branches): Runs on [Apache Gearpump (incubating)](http://gearpump.apache.org). 

## Choosing a Runner

Beam is designed to enable pipelines to be portable across these different runners. However, given the different capabilities of each runner, they do have different abilities to implement the core concepts in the Beam model. The [Capability Matrix](/learn/runners/capability-matrix) provides a detailed comparison of their functionality.

Once you have chosen which runner to use, see that runner's page to learn about any initial setup as well as required and optional PipelineOptions for configuring that runner's execution. Then go [run your first WordCount pipeline](/use/quickstart).



