---
layout: default
---
<p>
  <div class="alert alert-info alert-dismissible" role="alert">
  <span class="glyphicon glyphicon-flag" aria-hidden="true"></span>
  <button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>
  The Apache Beam project is in the process of bootstrapping. This includes the creation of project resources, the refactoring of the initial code submission, and the formulation of project documentation, planning, and design documents. For more information about Beam see the <a href="/getting_started/">getting started page</a>.
  </div>
</p>

# Beam Programming Guide

The **Beam Programming Guide** is intended for Beam users who want to use the Beam SDKs to create data processing pipelines. It contains guidance for using the Beam SDK classes to build and test your pipeline. It is not intended as an exhaustive reference, but as a higher-level guide to programmatically building your Beam pipeline.

## Contents

* [Overview](#overview)
* [Creating the Pipeline](#pipeline)
* [Working with PCollections](#pcollection)
  * [Creating a PCollection](#pccreate)
  * [PCollection Characteristics](#pccharacteristics)
    * [Element Type](#pcelementtype)
    * [Immutability](#pcimmutability)
    * [Random Access](#pcrandomaccess)
    * [Size and Boundedness](#pcsizebound)
    * [Element Timestamps](#pctimestamps)
* [Applying Transforms](#transform)
  * [ParDo](#pardo)
  * [GroupByKey](#gbk)
  * [Combine](#combine)
* [I/O](#io)
* [Running the Pipeline](#running)
* [Data Encoding and Type Safety](#coders)
* [Working with Windowing](#windowing)
* [Working with Triggers](#triggers)

## <a name="#overview"></a>Overview

To use Beam, you need to first create a driver program using the classes in one of the Beam SDKs. Your driver program *defines* your pipeline, including all of the inputs, transforms, and outputs; it also sets execution options for your pipeline, such as the Pipeline Runner (which, in turn, determines what back-end your pipeline will run on).

The Beam SDKs provide a number of abstractions that simplify the mechanics of large-scale distributed data processing. The same Beam abstractions work with both batch and streaming data sources. When you create your Beam pipeline, you can think about your data processing task in terms of these abstractions. They include:

* `Pipeline`: A `Pipeline` encapsulates your entire data processing task, from start to finish. This includes reading input data, transforming that data, and writing output data. All Beam driver programs must create a `Pipeline`. When you create the `Pipeline`, you must also specify the execution options that tell the `Pipeline` where and how to run.

* `PCollection`: A `PCollection` represents a distributed data set that your Beam pipeline operates on. The data set can be *bounded*, meaning it comes from a fixed source like a file, or *unbounded*, meaning it comes from a continuously updating source via a subscription or other mechanism. Your pipeline typically creates an initial `PCollection` by reading data from an external data source, but you can also create a `PCollection` from in-memory data within your driver program. From there, `PCollection`s are the inputs and outputs for each step in your pipeline.

* `Transform`: A `Transform` represents a data processing operation, or a step, in your pipeline. Every `Transform` takes one or more `PCollection` objects as input, perfroms a processing function that you provide on the elements of that `PCollection`, and produces one or more output `PCollection` objects. 

* I/O `Source` and `Sink`: Beam provides `Source` and `Sink` APIs to represent reading and writing data, respectively. `Source` encapsulates the code necessary to read data into your Beam pipeline from some external source, such as cloud file storage or a subscription to a streaming data source. `Sink` likewise encapsulates the code necessary to write the elements of a `PCollection` to an external data sink.

A typical Beam driver program works as follows:

* Create a `Pipeline` object and set the pipeline execution options, including the Pipeline Runner.
* Create an initial `PCollection` for pipeline data, either using the `Source` API to read data from an external source, or using a `Create` transform to build a `PCollection` from in-memory data.
* Apply **Transforms** to each `PCollection`. Transforms can change, filter, group, analyze, or otherwise process the elements in a `PCollection`. A transform creates a new output `PCollection` *without consuming the input collection*. A typical pipeline applies subsequent transforms to the each new output `PCollection` in turn until processing is complete.
* Output the final, transformed `PCollection`(s), typically using the `Sink` API to write data to an external source.
* **Run** the pipeline using the designated Pipeline Runner.

## <a name="#pipeline"></a>Creating the Pipeline

The `Pipeline` abstraction encapsulates all the data and steps in your data processing task. Your Beam driver program typically starts by constructing a [Pipeline](https://github.com/apache/incubator-beam/blob/master/sdks/java/core/src/main/java/org/apache/beam/sdk/Pipeline.java) object, and then using that object as the basis for creating the pipeline's data sets as `PCollection`s and its operations as `Transform`s.

To use Beam, your driver program must first create an instance of the Beam SDK class `Pipeline` (typically in the `main()` function). When you create your `Pipeline`, you'll also need to set some **configuration options**. You can set your pipeline's configuration options programatically, but it's often easier to set the options ahead of time (or read them from the command line) and pass them to the `Pipeline` object when you create the object.

The pipeline configuration options determine, among other things, the `PipelineRunner` that determines where the pipeline gets executed: locally, or using a distributed back-end of your choice. Depending on where your pipeline gets executed and what your specifed Runner requires, the options can also help you specify other aspects of execution.

To set your pipeline's configuration options and create the pipeline, create an object of type [PipelineOptions](https://github.com/apache/incubator-beam/blob/master/sdks/java/core/src/main/java/org/apache/beam/sdk/options/PipelineOptions.java) and pass it to `Pipeline.Create()`. The most common way to do this is by parsing arguments from the command-line:

```java
public static void main(String[] args) {
   // Will parse the arguments passed into the application and construct a PipelineOptions
   // Note that --help will print registered options, and --help=PipelineOptionsClassName
   // will print out usage for the specific class.
   PipelineOptions options =
       PipelineOptionsFactory.fromArgs(args).create();

   Pipeline p = Pipeline.create(options);
```

The Beam SDKs contain various subclasses of `PipelineOptions` that correspond to different Runners. For example, `DirectPipelineOptions` contains options for the Direct (local) pipeline runner, while `DataflowPipelineOptions` contains options for using the runner for Google Cloud Dataflow. You can also define your own custom `PipelineOptions` by creating an interface that extends the Beam SDKs' `PipelineOptions` class.

## <a name="#pcollection"></a>Working with PCollections

The [PCollection](https://github.com/apache/incubator-beam/blob/master/sdks/java/core/src/main/java/org/apache/beam/sdk/values/PCollection.java) abstraction represents a potentially distributed, multi-element data set. You can think of a `PCollection` as "pipeline" data; Beam transforms use `PCollection` objects as inputs and outputs. As such, if you want to work with data in your pipeline, it must be in the form of a `PCollection`.

After you've created your `Pipeline`, you'll need to begin by creating at least one `PCollection` in some form. The `PCollection` you create serves as the input for the first operation in your pipeline.

### <a name="#pccreate"></a>Creating a PCollection

You create a `PCollection` by either reading data from an external source using Beam's [Source API](#io), or you can create a `PCollection` of data stored in an in-memory collection class in your driver program. The former is typically how a production pipeline would ingest data; Beam's Source APIs contain adapters to help you read from external sources like large cloud-based files, databases, or subscription services. The latter is primarily useful for testing and debugging purposes.

#### Reading from an External Source

To read from an external source, you use one of the [Beam-provided I/O adapters](#io). The adapters vary in their exact usage, but all of them from some external data source and return a `PCollection` whose elements represent the data records in that source. 

Each data source adapter has a `Read` transform; to read, you must apply that transform to the `Pipeline` object itself. `TextIO.Read`, for example, reads from an external text file and returns a `PCollection` whose elements are of type `String`; each `String` represents one line from the text file. Here's how you would apply `TextIO.Read` to your `Pipeline` to create a `PCollection`:

```java
public static void main(String[] args) {
    // Create the pipeline.
    PipelineOptions options = 
        PipelineOptionsFactory.fromArgs(args).create();
    Pipeline p = Pipeline.create(options);

    PCollection<String> lines = p.apply(
      TextIO.Read.named("ReadMyFile").from("gs://some/inputData.txt"));
}
```

See the [section on I/O](#io) to learn more about how to read from the various data sources supported by the Beam SDK.

#### Creating a PCollection from In-Memory Data

To create a `PCollection` from an in-memory Java `Collection`, you use the Beam-provided `Create` transform. Much like a data adapter's `Read`, you apply `Create` sirectly to your `Pipeline` object itself. 

As parameters, `Create` accepts the Java `Collection` and a `Coder` object. The `Coder` specifies how the elements in the `Collection` should be [encoded](#pcelementtype).

The following example code shows how to create a `PCollection` from an in-memory Java `List`:

```java
public static void main(String[] args) {
    // Create a Java Collection, in this case a List of Strings.
    static final List<String> LINES = Arrays.asList(
      "To be, or not to be: that is the question: ",
      "Whether 'tis nobler in the mind to suffer ",
      "The slings and arrows of outrageous fortune, ",
      "Or to take arms against a sea of troubles, ");

    // Create the pipeline.
    PipelineOptions options = 
        PipelineOptionsFactory.fromArgs(args).create();
    Pipeline p = Pipeline.create(options);

    // Apply Create, passing the list and the coder, to create the PCollection.
    p.apply(Create.of(LINES)).setCoder(StringUtf8Coder.of())
}
```
### <a name="#pccharacteristics">PCollection Characteristics

A `PCollection` is owned by the specific `Pipeline` object for which it is created; multiple pipelines cannot share a `PCollection`. In some respects, a `PCollection` functions like a collection class. However, a `PCollection` can differ in a few key ways:

#### <a name="#pcelementtype"></a>Element Type

The elements of a `PCollection` may be of any type, but must all be of the same type. However, to support distributed processing, Beam needs to be able to encode each individual element as a byte string (so elements can be passed around to distributed workers). The Beam SDKs provide a data encoding mechanism that includes built-in encoding for commonly-used types as well as support for specifying custom encodings as needed.

#### <a name="#pcimmutability"></a>Immutability

A `PCollection` is immutable. Once created, you cannot add, remove, or change individual elements. A Beam Transform might process each element of a `PCollection` and generate new pipeline data (as a new `PCollection`), *but it does not consume or modify the original input collection*.

#### <a name="#pcrandomaccess"></a>Random Access

A `PCollection` does not support random access to individual elements. Instead, Beam Transforms consider every element in a `PCollection` individually.

#### <a name="#pcsizebound"></a>Size and Boundedness

A `PCollection` is a large, immutable "bag" of elements. There is no upper limit on how many elements a `PCollection` can contain; any given `PCollection` might fit in memory on a single machine, or it might represent a very large distributed data set backed by a persistent data store.

A `PCollection` can be either **bounded** or **unbounded** in size. A **bounded** `PCollection` represents a data set of a known, fixed size, while an **unbounded** `PCollection` represents a data set of unlimited size. Whether a `PCollection` is bounded or unbounded depends on the source of the data set that it represents. Reading from a batch data source, such as a file or a database, creates a bounded `PCollection`. Reading from a streaming or continously-updating data source, such as Pub/Sub or Kafka, creates an unbounded `PCollection` (unless you explicitly tell it not to).

The bounded (or unbounded) nature The bounded (or unbounded) nature of your `PCollection` affects how Beam processes your data. A bounded `PCollection` can be processed using a batch job, which might read the entire data set once, and perform processing in a job of finite length. An unbounded `PCollection` must be processed using a streaming job that runs continuously, as the entire collection can never be available for processing at any one time.

When performing an operation that groups elements in an unbounded `PCollection`, Beam requires a concept called **Windowing** to divide a continuously updating data set into logical windows of finite size.  Beam processes each window as a bundle, and processing continues as the data set is generated. These logical windows are determined by some characteristic associated with a data element, such as a **timestamp**.

#### <a name="#pctimestamps"></a>Element Timestamps

Each element in a `PCollection` has an associated intrinsic **timestamp**. The timestamp for each element is initially assigned by the [Source](#io) that creates the `PCollection`. Sources that create an unbounded `PCollection` often assign each new element a timestamp that corresponds to when the element was read or added.

> **Note**: Sources that create a bounded `PCollection` for a fixed data set also automatically assign timestamps, but the most common behavior is to assign every element the same timestamp (`Long.MIN_VALUE`).

Timestamps are useful for a `PCollection` that contains elements with an inherent notion of time. If your pipeline is reading a stream of events, like Tweets or other social media messages, each element might use the time the event was posted as the element timestamp.

You can manually assign timestamps to the elements of a `PCollection` if the source doesn't do it for you. You'll want to do this if the elements have an inherent timestamp, but the timestamp is somewhere in the structure of the element itself (such as a "time" field in a server log entry). Beam has [Transforms](#transforms) that take a `PCollection` as input and output an identical `PCollection` with timestamps attached; see [Assigning Timestamps](#windowing) for more information on how to do so.

