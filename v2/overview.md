---
layout: v2default
title: "Apache Beam Overview"
---

# Overview

Apache Beam is an open source, unified programming model that you can use to create a data processing _pipeline_.

You start by building a program that defines the pipeline using one of the open source Beam SDKs.

The pipeline is then executed by one of Beam’s supported _distributed processing back-ends_, which include [Apache Flink](http://flink.apache.org), [Apache Spark](http://spark.apache.org), [Google Cloud Dataflow](https://cloud.google.com), ...

Apache Beam is particularly useful for [Embarrassingly Parallel](http://en.wikipedia.org/wiki/Embarassingly_parallel) data processing tasks, in which the problem can be decomposed into many smaller bundles of
data that can be processed independently and in parallel. You can also use Beam for Extract, Transform, and Load (ETL) tasks and pure data integration.

These tasks are useful for moving data between different storage media and data sources, transforming data into a more desirable format, or loading data onto a new system.

## SDKs and DSLs

The Apache Beam SDKs provide a unified programming model that can represent and transform data sets of any size, whether the input is a finite data set from a batch data source,
or an infinite data set from a streaming data source. The Apache Beam SDKs use the same classes to represent both bounded and unbounded data, and the same transforms to operate
on that data. You use the Apache Beam SDK of your choice to build a program that defines your data processing pipeline.

Apache Beam currently supports the following language-specific SDKs:

Language | Status |
--- | --- |
Java | Available |
Python | Coming Soon |
Scala | Coming Soon |
SQL | Idea |

## I/O connectors

Apache Beam provides I/O connectors allows your pipeline to read or write data to different backends.

I/O | Status |
--- | --- |
Google BigQuery | Available |
Google BigTable | Available |
Apache Cassandra | Coming Soon |
Google Datastore | Available |
Elasticsearch | Coming Soon |
JMS | Available |
Apache Kafka | Available |
Amazon Kinesis | Available |
MQTT | Coming Soon |
MongoDB | Available |
Apache Parquet | ToDo |

## Runners

The Apache Beam Pipeline Runners translate the data processing pipeline you define with your Apache Beam program into the API compatible with the distributed processing
back-end of your choice. When you run your Apache Beam program, you’ll need to specify the appropriate runner for the back-end where you want to execute your pipeline.

Apache Beam currently supports runners that work with the following distributed processing back-ends:

Runner | Status |
--- | --- |
Google Cloud Dataflow | Available |
Apache Flink | Available |
Apache Spark | Available |
Apache Apex | Coming Soon |
Apache Gearpump | Coming Soon |
Apache MapReduce | ToDo |

Note: You can always execute your pipeline locally for testing and debugging purposes.