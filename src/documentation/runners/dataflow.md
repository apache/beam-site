---
layout: default
title: "Cloud Dataflow Runner"
permalink: /documentation/runners/dataflow/
redirect_from: /learn/runners/dataflow/
---
# Using the Google Cloud Dataflow Runner

The Google Cloud Dataflow runner uses the [Cloud Dataflow managed service](https://cloud.google.com/dataflow/service/dataflow-service-desc). When you run your pipeline with the Cloud Dataflow service, the runner uploads your executable code and dependencies to a Google Cloud Storage bucket and creates a Cloud Dataflow job, which executes your pipeline on managed resources in Google Cloud Platform.

The Cloud Dataflow runner and service is suitable for large scale continuous jobs, and provides:

* a fully managed service
* [autoscaling](https://cloud.google.com/dataflow/service/dataflow-service-desc#autoscaling) of the number of VMs throughout the lifetime of the job
* [dynamic work rebalancing](https://cloud.google.com/blog/big-data/2016/05/no-shard-left-behind-dynamic-work-rebalancing-in-google-cloud-dataflow)

The [Beam Capability Matrix]({{ site.baseurl }}/documentation/runners/capability-matrix/) documents the supported capabilities of the Cloud Dataflow runner.

## Cloud Dataflow runner prerequisites and setup
To use the Cloud Dataflow runner, you must complete the following setup:

1. Select or create a Google Cloud Platform Console project.

2. Enable billing for your project.

3. Enable APIs: Cloud Dataflow, Compute Engine, Cloud Logging, Cloud Storage, Cloud Storage JSON, BigQuery, Cloud Pub/Sub, and Cloud Datastore.

4. Install the Cloud SDK.

5. Create a Cloud Storage bucket.
    * In the Cloud Platform Console, go to the Cloud Storage browser.
    * Click **Create bucket**.
    * In the **Create bucket** dialog, specify the following attributes:
      * _Name_: A unique bucket name. Do not include sensitive information in the bucket name, as the bucket namespace is global and publicly visible.
      * _Storage class_: Multi-Regional
      * _Location_:  Choose your desired location
    * Click **Create**.

For more information, see the *Before you begin* section of the [Cloud Dataflow quickstarts](https://cloud.google.com/dataflow/docs/quickstarts).

### Specify your dependency

You must specify your dependency on the Cloud Dataflow runner.

For example, if you are using Maven for development and want to use the SDK for Java with [DataflowRunner]({{ site.baseurl }}/documentation/sdks/javadoc/{{ site.release_latest }}/index.html?org/apache/beam/runners/dataflow/DataflowRunner.html), add the following dependency to your `pom.xml` file:

```
<dependency>
  <groupId>org.apache.beam</groupId>
  <artifactId>beam-runners-google-cloud-dataflow-java</artifactId>
  <version>0.3.0-incubating</version>
  <scope>runtime</scope>
</dependency>
```

### Authentication

Before running your pipeline, you must authenticate with the Google Cloud Platform. Run the following command to get [Application Default Credentials](https://developers.google.com/identity/protocols/application-default-credentials).

```
gcloud auth application-default login
```

## Pipeline options for the Cloud Dataflow runner

When executing your pipeline from the command-line, set these pipeline options.

<table class="table table-bordered">
<tr>
  <th>Field</th>
  <th>Description</th>
  <th>Default Value</th>
</tr>
<tr>
  <td><code>runner</code></td>
  <td>The pipeline runner to use. This option allows you to determine the pipeline runner at runtime.</td>
  <td>Set to <code>dataflow</code> to run on the Cloud Dataflow Service.</td>
</tr>
<tr>
  <td><code>project</code></td>
  <td>The project ID for your Google Cloud Project.</td>
  <td>If not set, defaults to the default project of the current user.</td>
</tr>
<tr>
  <td><code>streaming</code></td>
  <td>Whether streaming mode is enabled or disabled; <code>true</code> if enabled.</td>
  <td><code>false</code></td>
</tr>
<tr>
  <td><code>tempLocation</code></td>
  <td>Optional. Path for temporary files. If set to a valid Google Cloud Storage URL that begins with <code>gs://</code>, <code>tempLocation</code> is used as the default value for <code>gcpTempLocation</code>.</td>
  <td>No default value</td>
</tr>
<tr>
  <td><code>gcpTempLocation</code></td>
  <td>Cloud Storage bucket path for temporary files. Must be a valid Cloud Storage URL that begins with <code>gs://</code>.</td>
  <td>If not set, defaults to the value of <code>tempLocation</code>, provided that <code>tempLocation</code> is a valid Cloud Storage URL. If <code>tempLocation</code> is not a valid Cloud Storage URL, you must set <code>gcpTempLocation</code>.</td>
</tr>
<tr>
  <td><code>stagingLocation</code></td>
  <td>Cloud Storage bucket path for staging your binary and any temporary files. Must be a valid Cloud Storage URL that begins with <code>gs://</code>.</td>
  <td>If not set, defaults to a staging directory within <code>gcpTempLocation</code>.</td>
</tr>
</table>

See the reference documentation for the  <span class="language-java">[DataflowPipelineOptions]({{ site.baseurl }}/documentation/sdks/javadoc/{{ site.release_latest }}/index.html?org/apache/beam/runners/dataflow/options/DataflowPipelineOptions.html)</span><span class="language-python">[PipelineOptions](https://github.com/apache/incubator-beam/blob/python-sdk/sdks/python/apache_beam/utils/options.py)</span> interface (and its subinterfaces) for the complete list of pipeline configuration options.

## Additional information and caveats

### Monitoring your job

While your pipeline executes, you can monitor the job's progress, view details on execution, and receive updates on the pipeline's results by using the [Dataflow Monitoring Interface](https://cloud.google.com/dataflow/pipelines/dataflow-monitoring-intf) or the [Dataflow Command-line Interface](https://cloud.google.com/dataflow/pipelines/dataflow-command-line-intf).

### Blocking Execution

To connect to your job and block until it is completed, call `waitToFinish` on the `PipelineResult` returned from `pipeline.run()`. The Cloud Dataflow runner prints job status updates and console messages while it waits. While the result is connected to the active job, note that typing **Ctrl+C** from the command line does not cancel your job. To cancel the job, you can use the [Dataflow Monitoring Interface](https://cloud.google.com/dataflow/pipelines/dataflow-monitoring-intf) or the [Dataflow Command-line Interface](https://cloud.google.com/dataflow/pipelines/dataflow-command-line-intf).

### Streaming Execution

If your pipeline uses an unbounded data source or sink, you must set the `streaming` option to `true`.

